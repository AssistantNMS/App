// ignore_for_file: avoid_print

import 'dart:io';
import 'package:assistantnms_app/env.dart';

Future<void> main() async {
  final pubSpecFile = File('./pubspec.yaml');
  String pubSpecString = await pubSpecFile.readAsString();

  RegExp identityNameReg = RegExp(r'identity_name:\s\w+');
  String newDoc = pubSpecString.replaceAllMapped(identityNameReg, (match) {
    return 'identity_name: $identityName';
  });

  RegExp publisherReg = RegExp(r'publisher:\s\w+');
  newDoc = newDoc.replaceAllMapped(publisherReg, (match) {
    return 'publisher: $publisher';
  });

  final pubFile = File('./pubspec.yaml');
  await pubFile.writeAsString(newDoc);
  print('Writing to pubFile Success');
}
