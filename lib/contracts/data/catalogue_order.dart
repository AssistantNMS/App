// To parse this JSON data, do
//
//     final majorUpdateItem = majorUpdateItemFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class CatalogueOrder {
  final String id;
  final List<String> appIds;

  CatalogueOrder({
    required this.id,
    required this.appIds,
  });

  factory CatalogueOrder.fromRawJson(String str) =>
      CatalogueOrder.fromJson(json.decode(str));

  factory CatalogueOrder.fromJson(Map<String, dynamic>? json) => CatalogueOrder(
        id: readStringSafe(json, 'Id'),
        appIds: readStringListSafe(json, 'AppIds'),
      );
}
