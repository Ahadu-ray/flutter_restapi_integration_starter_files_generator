import 'dart:convert';
import 'dart:io';

import 'enums.dart';
import 'extensions.dart';

class FileService {
  static String _rootFolder = "/";

  set rootFolder(String dir) => _rootFolder = dir;

  static Future<Map<String, dynamic>> getJsonData() async {
    try {
      String? jsonFilePath = stdin.readLineSync();
      return await File(jsonFilePath!)
          .readAsString()
          .then((value) => jsonDecode(value));
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  static Future<String> createFolder({
    required String folderName,
  }) async {
    return await Directory(_rootFolder + folderName)
        .create(recursive: true)
        .then((value) => value.path);
  }

  static File createFile(
      {required String fileName, required ClassType classType}) {
    File file =
        File(_rootFolder + classType.folderName + '/${fileName.fileName}');
    file.createSync();
    return file;
  }
}
