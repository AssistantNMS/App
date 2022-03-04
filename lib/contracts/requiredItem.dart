// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class RequiredItem {
  String id;
  int quantity;

  RequiredItem({
    this.id,
    this.quantity,
  });

  @override
  String toString() {
    return "$id x$quantity";
  }

  factory RequiredItem.fromRawJson(String str) =>
      RequiredItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RequiredItem.fromJson(Map<String, dynamic> json) => RequiredItem(
        id: readStringSafe(json, 'Id'),
        quantity: readIntSafe(json, 'Quantity'),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Quantity": quantity,
      };
}
