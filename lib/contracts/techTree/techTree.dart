// To parse this JSON data, do
//
//     final techTree = techTreeFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import './techTreeNode.dart';
import '../enum/currency_type.dart';

class TechTree {
  String id;
  String name;
  CurrencyType costType;
  List<TechTreeNode> children;

  TechTree({
    required this.id,
    required this.name,
    required this.costType,
    required this.children,
  });

  factory TechTree.fromRawJson(String str) =>
      TechTree.fromJson(json.decode(str));

  factory TechTree.fromJson(Map<String, dynamic>? json) => TechTree(
        id: readStringSafe(json, 'Id'),
        name: readStringSafe(json, 'Name'),
        costType: currencyTypeValues.map[readStringSafe(json, 'CostType')]!,
        children: readListSafe(
          json,
          'Children',
          (x) => TechTreeNode.fromJson(x),
        ),
      );
}
