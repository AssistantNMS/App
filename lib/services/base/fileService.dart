import 'dart:io';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:download/download.dart';
import 'package:file_picker/file_picker.dart';

class FileService {
  Future<Result> saveFileLocally(
      String jsonContent, String title, String defaultFileName) async {
    try {
      final stream = Stream.fromIterable(jsonContent.codeUnits);

      String outputFile = defaultFileName;
      if (isWindows) {
        outputFile = await FilePicker.platform.saveFile(
          dialogTitle: title,
          fileName: defaultFileName,
        );

        if (outputFile == null) {
          // User canceled the picker
          return Result(false, 'Operation cancelled');
        }
      }

      getLog().d('save file to: ' + outputFile);
      download(stream, outputFile);

      return Result(true, '');
    } catch (ex) {
      return Result(false, ex.toString());
    }
  }

  Future<ResultWithValue<T>> readFileFromLocal<T>(
      T Function(String jsonContent) readFileFunc) async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles();

      if (result != null) {
        getLog().d('read file from: ' + result.files.single.path);
        File file = File(result.files.single.path);
        String fileContents = await file.readAsString();
        T obj = readFileFunc(fileContents);
        return ResultWithValue<T>(true, obj, '');
      } else {
        // User canceled the picker
        return ResultWithValue<T>(false, null, 'Operation cancelled');
      }
    } catch (ex) {
      return ResultWithValue<T>(false, null, ex.toString());
    }
  }
}
