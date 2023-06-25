import 'src/composer.dart';
import 'src/file_service.dart';

Future<void> main() async {
  // get collection and set destination path
  var jsonData = await FileService.getJsonData();

  Composer composer = Composer();
  composer.startBuild(repoJson: jsonData);
}
