// To parse this JSON data, do
//
//     final techTree = techTreeFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import './techTreeNode.dart';
import '../enum/currencyType.dart';

class TechTree {
  String id;
  String name;
  CurrencyType costType;
  List<TechTreeNode> children;

  TechTree({
    this.id,
    this.name,
    this.costType,
    this.children,
  });

  factory TechTree.fromRawJson(String str) =>
      TechTree.fromJson(json.decode(str));

  factory TechTree.fromJson(Map<String, dynamic> json) => TechTree(
        id: readStringSafe(json, 'Id'),
        name: readStringSafe(json, 'Name'),
        costType: currencyTypeValues.map[readStringSafe(json, 'CostType')],
        children: List<TechTreeNode>.from(
            json['Children'].map((x) => TechTreeNode.fromJson(x))),
      );
}
