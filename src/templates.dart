// contains functions that holds template for repositories, functions, adapter
// and models.

import 'enums.dart';
import 'extensions.dart';

String repositoryTemplate({
  required String repoName,
  required String functions,
}) {
  return "import \"../adapters/${repoName.toFunctionName}_adapter.dart\";\n"
      "import \"../models/freezed_models/freezed_models.dart\";\n"
      "class ${repoName.toClassName}Repository implements I${repoName.toClassName}Repository {\n"
      "final ApiClient apiClient;\n"
      "${repoName.toClassName}Repository({ required this.apiClient});"
      "$functions"
      "}";
}

String repoMethodTemplate({required MethodModel data}) {
  return "\n@override\n"
      "Future<bool> ${data.name}"
      "(${data.requestType.hasBody ? data.originalName.toClassName + 'RequestModel payload' : ''}) async {\n"
      "try {\n"
      "final response = await apiClient.request(\n"
      "requestType: ${data.requestType.toString()},\n"
      "path: '${data.path}',\n"
      "${data.requestType.hasBody ? 'data: payload.toJson(),\n' : ''});"
      "return response['success'];\n"
      "}catch (e) {\n"
      "return false;\n"
      "}\n"
      "}\n\n";
}

String adapterTemplate({
  required String repoName,
  required String methods,
}) {
  return "import \"../models/freezed_models/freezed_models.dart\";\n"
      "abstract class I${repoName.toClassName}Repository{\n"
      "$methods"
      "}";
}

String adapterMethodTemplate({required MethodModel model}) {
  return "Future<bool> ${model.name}(${model.hasPayload ? model.originalName.toClassName + 'RequestModel payload' : ''});";
}

String modelMethodTemplate({required String name, required String variables}) {
  return "\n@freezed\n"
      "abstract class ${name}RequestModel with _\$${name}RequestModel {\n"
      "\tfactory ${name}RequestModel({\n"
      "$variables\n"
      "\t}) = _${name}RequestModel;\n"
      "\tfactory ${name}RequestModel.fromJson(Map<String, dynamic> json) =>\n"
      "\t_\$${name}RequestModelFromJson(json);\n"
      "}";
}

// blueprint for what a method/function inside repositories needs to have when
// changing requests
class MethodModel {
  String name;
  RequestType requestType;
  String path;
  bool hasPayload;
  String originalName;

  MethodModel(
      {required this.name,
      required this.requestType,
      required this.path,
      required this.hasPayload,
      required this.originalName,
      });

  factory MethodModel.fromJson(Map<String, dynamic> json) => MethodModel(
        name: json['name'].toString().toFunctionName,
        requestType: json['request']['method'].toString().requestType,
        path: json['request']['url']['path'].join('/'),
        hasPayload: json['request']['body'] != null,
        originalName:json['name'],
      );
}
