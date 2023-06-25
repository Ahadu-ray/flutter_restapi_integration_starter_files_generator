import 'dart:convert';
import 'dart:io';

import 'enums.dart';
import 'extensions.dart';

class FileService {
  static late String _rootFolder;

  set rootFolder(String dir) => _rootFolder = dir;

  // accept postman collection and root folder for output, and create
  // appropriate folders accordingly and return the json format of the collection
  static Future<Map<String, dynamic>> getJsonData() async {
    try {
      print("Enter file path");
      String? jsonFilePath = stdin.readLineSync();
      print("Enter destination path");
      _rootFolder = stdin.readLineSync() ?? "C:\\Users\\Ahadu\\Desktop\\out\\";

      ClassType.values.forEach((element) {
        FileService.createFolder(folderName: element.toFolderName);
      });

      return await File(jsonFilePath!)
          .readAsString()
          .then((value) => jsonDecode(value));
    } catch (e) {
      return Future.error(e);
    }
  }

  // method to create folder
  static Future<String> createFolder({
    required String folderName,
  }) async {
    try {
      return await Directory(_rootFolder + folderName)
          .create(recursive: true)
          .then((value) {
        return value.path;
      });
    } catch (e) {
      return Future.error(e);
    }
  }

  // method to create files and sets file name depending on the class type
  // eg. auth_repository,auth_adapter and freezed_model
  static File createFile(
      {required String fileName, required ClassType classType}) {
    File file = File(_rootFolder +
        classType.toFolderName +
        getSlash() +
        '${(classType != ClassType.model ? fileName + " " + (classType.name) : fileName).toFileName}');
        print(file.path);
    return file;
  }
}
