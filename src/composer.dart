import 'dart:io';

import 'enums.dart';
import 'file_service.dart';

class Composer {
  void creatRepository({required String className, required String data}) {
    File repo = FileService.createFile(
        fileName: className, classType: ClassType.repository);
  }
}
