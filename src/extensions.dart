import 'enums.dart';

extension on ClassType {
  get folderName {
    return "${this.name[0].toUpperCase()}${this.name.substring(1).toLowerCase()}";
  }
}

extension on String {
  get className {
    // return
  }
}
