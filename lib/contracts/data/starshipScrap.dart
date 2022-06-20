// To parse this JSON data, do
//
//     final starshipScrap = starshipScrapFromMap(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class StarshipScrap {
  StarshipScrap({
    this.shipType,
    this.shipClassType,
    this.itemDetails,
  });

  String shipType;
  String shipClassType;
  List<StarshipScrapItemDetail> itemDetails;

  factory StarshipScrap.fromJson(Map<String, dynamic> json) => StarshipScrap(
        shipType: readStringSafe(json, 'ShipType'),
        shipClassType: readStringSafe(json, 'ShipClassType'),
        itemDetails: readListSafe(
          json,
          'ItemDetails',
          (x) => StarshipScrapItemDetail.fromMap(x),
        ),
      );
}

class StarshipScrapItemDetail {
  StarshipScrapItemDetail({
    this.id,
    this.percentageChance,
    this.amountMin,
    this.amountMax,
  });

  String id;
  double percentageChance;
  int amountMin;
  int amountMax;

  factory StarshipScrapItemDetail.fromJson(String str) =>
      StarshipScrapItemDetail.fromMap(json.decode(str));

  factory StarshipScrapItemDetail.fromMap(Map<String, dynamic> json) =>
      StarshipScrapItemDetail(
        id: readStringSafe(json, 'Id'),
        percentageChance: readDoubleSafe(json, 'PercentageChance'),
        amountMin: readIntSafe(json, 'AmountMin'),
        amountMax: readIntSafe(json, 'AmountMax'),
      );
}
