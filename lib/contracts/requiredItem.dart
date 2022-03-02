// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

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

  factory RequiredItem.fromJson(Map<String, dynamic> json) => new RequiredItem(
        id: json["Id"] as String,
        quantity: json["Quantity"] as int,
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Quantity": quantity,
      };
}
