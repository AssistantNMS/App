import 'dart:convert';

import 'package:assistantapps_flutter_common/helpers/jsonHelper.dart';

class GeneratedMeta {
  GeneratedMeta({
    this.gameVersion,
    this.generatedDate,
  });

  String gameVersion;
  DateTime generatedDate;

  factory GeneratedMeta.fromRawJson(String str) =>
      GeneratedMeta.fromJson(json.decode(str));

  factory GeneratedMeta.fromJson(Map<String, dynamic> json) => GeneratedMeta(
        gameVersion: readStringSafe(json, "GameVersion"),
        generatedDate: readDateSafe(json, "GeneratedDate"),
      );
}
