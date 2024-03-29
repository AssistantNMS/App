import 'dart:io';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:download/download.dart';
import 'package:file_picker/file_picker.dart';

class FileService {
  Future<Result> saveFileLocally(
    String jsonContent,
    String title,
    String defaultFileName,
  ) async {
    try {
      final stream = Stream.fromIterable(jsonContent.codeUnits);

      String? outputFile = defaultFileName;
      if (isWindows) {
        outputFile = await FilePicker.platform.saveFile(
          dialogTitle: title,
          fileName: defaultFileName,
        );

        if (outputFile == null) {
          // User canceled the picker
          return Result(false, 'Operation cancelled');
        }
      } else {
        String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();
        outputFile = (selectedDirectory ?? '') + '/' + defaultFileName;
      }

      getLog().d('save file to: ' + outputFile);
      await download(stream, outputFile);

      File file = File(outputFile);
      await file.readAsString(); // Try read the file to ensure it exists

      return Result(true, '');
    } catch (ex) {
      getLog().d(ex.toString());
      return Result(false, ex.toString());
    }
  }

  Future<ResultWithValue<T?>> readFileFromLocal<T>(
    T Function(String jsonContent) readFileFunc,
  ) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        String? selectedFilePath = result.files.first.path;
        if (selectedFilePath == null) throw Exception('Invalid file selected');

        getLog().d('read file from: ' + selectedFilePath);
        File file = File(selectedFilePath);
        String fileContents = await file.readAsString();
        T obj = readFileFunc(fileContents);
        return ResultWithValue<T?>(true, obj, '');
      } else {
        // User canceled the picker
        return ResultWithValue<T?>(false, null, 'Operation cancelled');
      }
    } catch (ex) {
      return ResultWithValue<T?>(false, null, ex.toString());
    }
  }
}
