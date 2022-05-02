// ignore_for_file: avoid_print

import 'dart:io';
import 'package:pubspec_parse/pubspec_parse.dart';

Future<void> main() async {
  final pubSpecFile = File('./pubspec.yaml');
  var pubSpecString = await pubSpecFile.readAsString();
  var doc = Pubspec.parse(pubSpecString);

  // print(doc.version.build);
  await writeBuildNumFile(doc.version.build[0].toString());
  print('Done');
}

Future writeBuildNumFile(String buildNum) async {
  if (buildNum.isEmpty) return;
  print('Writing to appVersionNum.dart');
  final file = File('./lib/env/appVersionNum.dart');
  await file.writeAsString('const appsBuildNum = $buildNum;');
  print('Writing to file Success');
}
