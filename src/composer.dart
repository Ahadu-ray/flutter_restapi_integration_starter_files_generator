// main script
import 'dart:convert';
import 'dart:io';

import 'enums.dart';
import 'extensions.dart';
import 'file_service.dart';
import 'templates.dart';

class Composer {
  // currentRepoJson is the folder that is currently selected when in loop,
  // methods are those belonging to the folder,
  late Set<String> _methods;
  late Map<String, dynamic> _currentRepoJson;

  // models from the whole collection
  static String models = "";

  // start building
  void startBuild({required Map<String, dynamic> repoJson}) {
    repoJson['item'].forEach((folder) {
      // for every 'folder' create methods, then repositories, then adapter.
      _currentRepoJson = folder;
      _createMethods(json: _currentRepoJson['item']);
      _createRepository();
      _createAdapter();
    });

    // once all the models in the collection are gathered save them to a file
    _saveModels();
  }

  void _createMethods({required List<dynamic> json}) {
    // empty strings to hold methods. repo methods is for methods with their implementations written as 
    // repositories expect that. adapter methods are only function definitions since adapters expect that.
    String repoMethods = "", adapterMethods = "";
    
    // create methods: if the current folder have child folder inside it: data[item] will be List<dynamic>
    // as it will contain list of folder, else there will be data[request] instead, which is the method.
    json.forEach((data) {
      if (data['item'] is List<dynamic>) {
        _createMethods(json: data['item']);
      } else {
        MethodModel model = MethodModel.fromJson(data);
        // if current request has payload that is put as json, create model for that request payload
        if (model.hasPayload && data['request']?['body']?['mode'] == 'raw') {
          _createModel(
              name: data['name'], body: data['request']['body']['raw']);
        }

        repoMethods += repoMethodTemplate(data: model) + "\n";
        adapterMethods += adapterMethodTemplate(model: model) + "\n";
      }
    });
    _methods = {repoMethods, adapterMethods};
  }

// create repository file based on current class and write string from template together with methods
  void _createRepository() {
    File repo = FileService.createFile(
        fileName: _currentRepoJson['name'], classType: ClassType.repository);
    String repoTemplate = repositoryTemplate(
        repoName: _currentRepoJson['name'], functions: _methods.first);
    repo.writeAsString(repoTemplate);
  }

// create adapter file based on current class and write string from template together with methods
  void _createAdapter() {
    File adapter = FileService.createFile(
        fileName: _currentRepoJson['name'], classType: ClassType.adapter);
    String adapTemplate = adapterTemplate(
        repoName: _currentRepoJson['name'], methods: _methods.last);
    adapter.writeAsString(adapTemplate);
  }

// generate all variables needed in a single model and create the models with the template stored
  _createModel({
    required String name,
    required String body,
  }) {
    try{
    String variables = _getModelVariable(body: jsonDecode(body));
    models += modelMethodTemplate(name: name.toClassName, variables: variables);
    } catch (e) {
      print(name+"\n"+body.runtimeType.toString());
      print(e);
    }
  }

// returns the variables taken from request body with the right data types. If variable on the json 
// is List, save the variable definition and create model for each item in that list. if it is a map, 
// create new model for the value while wrting it as variable with name from the key. if data type is
// null use dynamic, else use the appropriate ones.
  String _getModelVariable({
    required Map<String, dynamic> body,
  }) {
    String variables = "\t\t";
    var type;
    body.forEach((key, value) {
      type = value.runtimeType;
      if (type is List<dynamic>) {
        value.forEach((tempKey, tempValue) {
          _createModel(name: key, body: tempValue);
          variables += "List<${key.toClassName}Request> $key,\n";
        });
      } else if (value is Map<String, dynamic>) {
        _createModel(name: key, body: jsonEncode(value));
        variables += (key.toString() + " Request").toClassName + " $key,\n";
      } else if (type == Null) {
        variables += "dynamic ${key},\n";
      } else {
        variables = variables + "$type? ${key},\n";
      }
      variables += "\t\t";
    });
    return variables;
  }

// save models to file 
  void _saveModels() {
    File model = FileService.createFile(
        fileName: 'freezed_models', classType: ClassType.model);

    model.writeAsString(models);
  }
}
