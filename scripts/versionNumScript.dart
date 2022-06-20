// ignore_for_file: avoid_print

import 'dart:io';
import 'package:pubspec_parse/pubspec_parse.dart';

Future<void> main() async {
  final pubSpecFile = File('./pubspec.yaml');
  var pubSpecString = await pubSpecFile.readAsString();
  var doc = Pubspec.parse(pubSpecString);

  String buildName = doc.version.major.toString() + '.';
  buildName += doc.version.minor.toString() + '.';
  buildName += doc.version.patch.toString();

  String buildNum = doc.version.build[0].toString();
  // String buildNum = doc.version.build[0].toString();
  await writeBuildNumFile(buildNum, buildName);
  print('Done');
}

Future writeBuildNumFile(String buildNum, String buildName) async {
  if (buildNum.isEmpty) return;
  print('Writing to appVersionNum.dart');
  final file = File('./lib/env/appVersionNum.dart');
  String contents = 'const appsBuildNum = $buildNum;\n';
  contents += 'const appsBuildName = \'$buildName\';';
  await file.writeAsString(contents);
  print('Writing to file Success');
}
