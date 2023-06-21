import 'dart:convert';
import 'dart:io';

import 'enums.dart';

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

  static Future<String> createFolder(
      {required String folderName,
      ClassType classType = ClassType.repository}) async {
    return await Directory('')
        .create(recursive: true)
        .then((value) => value.path);
  }

  // static Future<void> createFile({required String fileName}) {}
}
