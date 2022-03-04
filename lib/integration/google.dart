import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/AppConfig.dart';
import '../constants/GoogleDrive.dart';

const List<String> scopes = [DriveApi.driveFileScope];
const String jsonMimeType = 'application/json';
const String googleFolderMimeType = 'application/vnd.google-apps.folder';

Future<ResultWithValue<AccessCredentials>> _getGoogleCredentials() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  try {
    var credentialsString = preferences.getString(AppConfig.sharedPrefCredKey);
    var accessToken = _accessCredentialsFromJson(
        json.decode(credentialsString) as Map<String, dynamic>);
    if (accessToken.accessToken.expiry.isAfter(DateTime.now().toUtc())) {
      return ResultWithValue<AccessCredentials>(true, accessToken, '');
    }
  } catch (exception) {
    getLog().e('load from pref: ${exception.toString()}');
  }

  var id = ClientId(AppConfig.googleClientId, AppConfig.googleSecret);
  var client = http.Client();
  try {
    AccessCredentials credentials = await obtainAccessCredentialsViaUserConsent(
        id, scopes, client, launchExternalURL);
    await preferences.setString(
      AppConfig.sharedPrefCredKey,
      json.encode(_accessCredentialsToJson(credentials)),
    );
    return ResultWithValue<AccessCredentials>(true, credentials, '');
  } catch (exception) {
    getLog().e('user give consent: ${exception.toString()}');
    return ResultWithValue<AccessCredentials>(
        false, null, exception.toString());
  } finally {
    client.close();
  }
}

Future<Result> writeJsonFileToGoogleDriveOLD(
    String filename, String data) async {
  var googleCredResult = await _getGoogleCredentials();
  if (googleCredResult.hasFailed) return googleCredResult;

  var client = authenticatedClient(http.Client(), googleCredResult.value);
  var driveApi = DriveApi(client);

  String folderId;
  bool folderExists = false;

  var files = await driveApi.files.list();
  for (var file in files.files) {
    if (file.name != GoogleDrive.folderNameOLD) continue;
    folderId = file.id;
    folderExists = true;
    break;
  }

  if (!folderExists) {
    var _createFolder = await driveApi.files.create(
      File()
        ..name = GoogleDrive.folderNameOLD
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

Future<ResultWithValue<String>> _readJsonFileFromGoogleDriveOLD(
    String filename) async {
  var googleCredResult = await _getGoogleCredentials();
  if (googleCredResult.hasFailed) return ResultWithValue<String>(false, '', '');

  var client = authenticatedClient(http.Client(), googleCredResult.value);
  var driveApi = DriveApi(client);

  String fileToReadId;
  bool fileToReadExists = false;

  var files = await driveApi.files.list();
  for (var file in files.files) {
    if (file.name != filename) continue;
    fileToReadId = file.id;
    fileToReadExists = true;
    break;
  }

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

Future<ResultWithValue<T>> readGenericJsonFileFromGoogleDriveOLD<T>(
    String filename, Function(Map<String, dynamic> json) fromJson) async {
  var readFileResult = await _readJsonFileFromGoogleDriveOLD(filename);
  if (readFileResult.hasFailed) return ResultWithValue<T>(false, null, '');

  try {
    var driveFile = fromJson(json.decode(readFileResult.value));
    return ResultWithValue<T>(true, driveFile, '');
  } catch (exception) {
    if (exception is String) getLog().e(exception);
    return ResultWithValue<T>(false, null, exception.toString());
  }
}

Map<String, dynamic> _accessCredentialsToJson(
        AccessCredentials accessCredentials) =>
    {
      'accessToken': _accessTokenToJson(accessCredentials.accessToken),
      'refreshToken': accessCredentials.refreshToken,
      'idToken': accessCredentials.idToken,
      'scopes': accessCredentials.scopes,
    };

Map<String, dynamic> _accessTokenToJson(AccessToken accessToken) => {
      'data': accessToken.data,
      'expiry': accessToken.expiry.toIso8601String(),
      'type': accessToken.type,
    };

AccessCredentials _accessCredentialsFromJson(Map<String, dynamic> json) =>
    AccessCredentials(
      _accessTokenFromJson(json["accessToken"]),
      json["refreshToken"] as String,
      (json["scopes"] as List).map((i) => i as String).toList(),
      idToken: json["idToken"] as String,
    );

AccessToken _accessTokenFromJson(Map<String, dynamic> json) => AccessToken(
      json["type"] as String,
      json["data"] as String,
      DateTime.parse(json["expiry"] as String).toUtc(),
    );
