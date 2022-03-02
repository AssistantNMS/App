// To parse this JSON data, do
//
//     final unlockableTechTree = unlockableTechTreeFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import './techTree.dart';

class UnlockableTechTree {
  String id;
  String name;
  List<TechTree> trees;

  UnlockableTechTree({
    this.id,
    this.name,
    this.trees,
  });

  factory UnlockableTechTree.fromRawJson(String str) =>
      UnlockableTechTree.fromJson(json.decode(str));

  factory UnlockableTechTree.fromJson(Map<String, dynamic> json) =>
      UnlockableTechTree(
        id: readStringSafe(json, 'Id'),
        name: readStringSafe(json, 'Name'),
        trees:
            List<TechTree>.from(json["Trees"].map((x) => TechTree.fromJson(x))),
      );
}
