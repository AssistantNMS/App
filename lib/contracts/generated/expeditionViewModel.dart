// To parse this JSON data, do
//
//     final expedition = expeditionFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class ExpeditionViewModel {
  ExpeditionViewModel({
    required this.guid,
    required this.name,
    required this.link,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
  });

  String guid;
  String name;
  String? link;
  String imageUrl;
  DateTime startDate;
  DateTime endDate;

  factory ExpeditionViewModel.fromRawJson(String str) =>
      ExpeditionViewModel.fromJson(json.decode(str));

  factory ExpeditionViewModel.fromJson(Map<String, dynamic>? json) =>
      ExpeditionViewModel(
        guid: readStringSafe(json, 'guid'),
        name: readStringSafe(json, 'name'),
        link: readStringSafe(json, 'link'),
        imageUrl: readStringSafe(json, 'imageUrl'),
        startDate: readDateSafe(json, 'startDate'),
        endDate: readDateSafe(json, 'endDate'),
      );
}
