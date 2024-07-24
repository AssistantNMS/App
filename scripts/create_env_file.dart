// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  Map<String, String> env = Platform.environment;

  final file = File('./lib/env.dart');
  String? contentsInBase64 = env['ENV_DART'];
  if (contentsInBase64 == null) {
    print('Environment variable is empty');
    return;
  }
  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  String contents = stringToBase64.decode(contentsInBase64);
  await file.writeAsString(contents);
  print('Done');
}
