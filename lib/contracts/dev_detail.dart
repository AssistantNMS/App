// To parse this JSON data, do
//
//     final devDetail = devDetailFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class DevDetail {
  DevDetail({
    required this.id,
    required this.properties,
  });

  String id;
  List<DevProperty> properties;

  factory DevDetail.fromRawJson(String str) =>
      DevDetail.fromJson(json.decode(str));

  factory DevDetail.fromJson(Map<String, dynamic>? json) => DevDetail(
        id: readStringSafe(json, 'Id'),
        properties: readListSafe<DevProperty>(
          json,
          'Properties',
          (dynamic json) => DevProperty.fromJson(json),
        ),
      );
}

class DevProperty {
  DevProperty({
    required this.name,
    required this.value,
    required this.type,
  });

  String name;
  String value;
  int type;

  factory DevProperty.fromRawJson(String str) =>
      DevProperty.fromJson(json.decode(str));

  factory DevProperty.fromJson(Map<String, dynamic>? json) => DevProperty(
        name: readStringSafe(json, 'Name'),
        value: readStringSafe(json, 'Value'),
        type: readIntSafe(json, 'Type'),
      );
}
