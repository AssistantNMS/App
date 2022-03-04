import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

import '../constants/GoogleDrive.dart';

import 'googleHttpClient.dart';

const jsonMimeType = 'application/json';
const googleFolderMimeType = 'application/vnd.google-apps.folder';

Future<ResultWithValue<String>> _readJsonFileFromGoogleDrive(
    GoogleSignInAccount account, String filename) async {
  getLog().d('_readJsonFileFromGoogleDrive');
  var client = GoogleHttpClient(await account.authHeaders);
  DriveApi driveApi = DriveApi(client);

  String fileToReadId;
  bool fileToReadExists = false;

  var files = await driveApi.files.list();
  for (var file in files.files) {
    if (file.name != filename) continue;
    fileToReadId = file.id;
    fileToReadExists = true;
    break;
  }

  getLog().d('fileToReadExists: ' + fileToReadExists.toString());
  if (fileToReadExists) {
    try {
      Media driveFileResult = await driveApi.files
          .get(fileToReadId, downloadOptions: DownloadOptions.fullMedia);

      var byteArrayContent = await driveFileResult.stream.first;
      var content = utf8.decode(byteArrayContent);

      return ResultWithValue<String>(true, content, '');
    } catch (exception) {
      getLog().e('read file: ${exception.toString()}');
    }
  }

  return ResultWithValue<String>(false, '', '');
}

Future<ResultWithValue<T>> readGenericJsonFileFromGoogleDrive<T>(
  GoogleSignInAccount account,
  String filename,
  Function(Map<String, dynamic> json) fromJson,
) async {
  var readFileResult = await _readJsonFileFromGoogleDrive(account, filename);
  if (readFileResult.hasFailed) return ResultWithValue<T>(false, null, '');

  try {
    var driveFile = fromJson(json.decode(readFileResult.value));
    return ResultWithValue<T>(true, driveFile, '');
  } catch (exception) {
    if (exception is String) getLog().e(exception);
    return ResultWithValue<T>(false, null, exception.toString());
  }
}

Future<Result> writeJsonFileToGoogleDrive(
    GoogleSignInAccount account, String filename, String data) async {
  var client = GoogleHttpClient(await account.authHeaders);
  DriveApi driveApi = DriveApi(client);

  String folderId;
  bool folderExists = false;

  var files = await driveApi.files.list();
  for (var file in files.files) {
    if (file.name != GoogleDrive.folderName) continue;
    folderId = file.id;
    folderExists = true;
    break;
  }

  if (!folderExists) {
    var _createFolder = await driveApi.files.create(
      File()
        ..name = GoogleDrive.folderName
        ..mimeType = googleFolderMimeType,
    );
    folderId = _createFolder.id;
  }

  String fileToWriteId;
  bool fileToWriteExists = false;
  for (var file in files.files) {
    if (file.name != filename) continue;
    fileToWriteId = file.id;
    fileToWriteExists = true;
    break;
  }

  List<int> contentByteArray = utf8.encode(data);
  Media uploadMedia = Media(
    Stream.value(contentByteArray),
    contentByteArray.length,
    contentType: jsonMimeType,
  );

  if (fileToWriteExists) {
    driveApi.files.update(
      File()..name = filename,
      fileToWriteId,
      uploadMedia: uploadMedia,
    );
  } else {
    driveApi.files.create(
      File()
        ..name = filename
        ..parents = [folderId],
      uploadMedia: uploadMedia,
    );
  }
  return Result(true, '');
}
