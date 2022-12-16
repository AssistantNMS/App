// ignore_for_file: avoid_print

import 'dart:io';
import 'package:git/git.dart';
import 'package:path/path.dart' as p;
import 'package:pubspec_parse/pubspec_parse.dart';

Future<void> main() async {
  final pubSpecFile = File('./pubspec.yaml');
  String pubSpecString = await pubSpecFile.readAsString();
  Pubspec doc = Pubspec.parse(pubSpecString);

  String buildName = doc.version.major.toString() + '.';
  buildName += doc.version.minor.toString() + '.';
  buildName += doc.version.patch.toString();

  String buildNum = doc.version.build[0].toString();

  final gitDir = await GitDir.fromExisting(p.current);
  final commit = await gitDir.commits();

  await updatePubspecFile(pubSpecString, buildName);
  await writeBuildNumFile(buildNum, buildName, commit.keys.first);
  await updateInnoFile(buildName);
  print('Done');
}

Future writeBuildNumFile(
  String buildNum,
  String buildName,
  String latestCommit,
) async {
  if (buildNum.isEmpty) return;
  print('Writing to appVersionNum.dart');
  final file = File('./lib/env/appVersionNum.dart');
  String contents = 'const appsBuildNum = $buildNum;\n';
  contents += 'const appsBuildName = \'$buildName\';\n';
  contents += 'const appsCommit = \'$latestCommit\';';
  await file.writeAsString(contents);
  print('Writing to file Success');
}

Future updatePubspecFile(String doc, String buildNum) async {
  RegExp msixVersionReg = RegExp(r'msix_version:\s\d*\.\d*\.\d*\.\d*');
  final newDoc = doc.replaceAllMapped(msixVersionReg, (match) {
    return 'msix_version: $buildNum.0';
  });

  final pubFile = File('./pubspec.yaml');
  await pubFile.writeAsString(newDoc);
  print('Writing to pubFile Success');
}

Future updateInnoFile(String buildName) async {
  final innoFile = File('./installers/assistantNMS.iss');
  String innoFileString = await innoFile.readAsString();

  RegExp appVersionReg = RegExp(r'#define\sMyAppVersion\s\"\d*\.\d*\.\d*\"');
  final newDoc = innoFileString.replaceAllMapped(appVersionReg, (match) {
    return '#define MyAppVersion "$buildName"';
  });

  await innoFile.writeAsString(newDoc);
  print('Writing to innoSetup file Success');
}
