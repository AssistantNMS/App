// To parse this JSON data, do
//
//     final release = releaseFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class ReleaseNote {
  String name;
  String description;
  String link;
  bool isPc;
  bool isPs4;
  bool isPs5;
  bool isXb1;
  bool isXbsx;
  bool isNsw;
  bool isMac;

  ReleaseNote({
    required this.name,
    required this.description,
    required this.link,
    required this.isPc,
    required this.isPs4,
    required this.isPs5,
    required this.isXb1,
    required this.isXbsx,
    required this.isNsw,
    required this.isMac,
  });

  factory ReleaseNote.fromRawJson(String str) =>
      ReleaseNote.fromJson(json.decode(str));

  factory ReleaseNote.fromJson(Map<String, dynamic>? json) => ReleaseNote(
        name: readStringSafe(json, 'name'),
        description: readStringSafe(json, 'description'),
        link: readStringSafe(json, 'link'),
        isPc: readBoolSafe(json, 'isPc'),
        isPs4: readBoolSafe(json, 'isPs4'),
        isPs5: readBoolSafe(json, 'isPs5'),
        isXb1: readBoolSafe(json, 'isXb1'),
        isXbsx: readBoolSafe(json, 'isXbsx'),
        isNsw: readBoolSafe(json, 'isNsw'),
        isMac: readBoolSafe(json, 'isMac'),
      );
}
