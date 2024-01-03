// ignore_for_file: avoid_print

import 'dart:io';

Future<void> main() async {
  print('Writing to platform_type.dart');
  final file = File('./lib/env/platform_type.dart');
  String contents = 'const isGithubWindowsInstaller = true;\n';
  print('Writing to file Success');
  await file.writeAsString(contents);
  print('Done');
}
