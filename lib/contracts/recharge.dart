// To parse this JSON data, do
//
//     final recharge = rechargeFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'chargeBy.dart';

class Recharge {
  Recharge({
    this.id,
    this.totalChargeAmount,
    this.chargeBy,
  });

  String id;
  int totalChargeAmount;
  List<ChargeBy> chargeBy;

  factory Recharge.initial() => Recharge(
        id: '',
        totalChargeAmount: 0,
        chargeBy: List.empty(),
      );

  factory Recharge.fromRawJson(String str) =>
      Recharge.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Recharge.fromJson(Map<String, dynamic> json) => Recharge(
        id: readStringSafe(json, 'Id'),
        totalChargeAmount: readIntSafe(json, 'TotalChargeAmount'),
        chargeBy: readListSafe(json, 'ChargeBy', (x) => ChargeBy.fromJson(x)),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "TotalChargeAmount": totalChargeAmount,
        "ChargeBy": List.from(chargeBy.map((x) => x.toJson())),
      };
}
