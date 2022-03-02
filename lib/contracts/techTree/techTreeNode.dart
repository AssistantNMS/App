// To parse this JSON data, do
//
//     final techTreeNode = techTreeNodeFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class TechTreeNode {
  String id;
  String icon;
  String title;
  int cost;
  List<TechTreeNode> children;

  TechTreeNode({
    this.id,
    this.icon,
    this.title,
    this.cost,
    this.children,
  });

  factory TechTreeNode.fromRawJson(String str) =>
      TechTreeNode.fromJson(json.decode(str));

  factory TechTreeNode.fromJson(Map<String, dynamic> json) => TechTreeNode(
        id: readStringSafe(json, 'Id'),
        icon: readStringSafe(json, 'Icon'),
        title: readStringSafe(json, 'Title'),
        cost: readIntSafe(json, "Cost"),
        children: List<TechTreeNode>.from(
            json["Children"].map((x) => TechTreeNode.fromJson(x))),
      );
}
