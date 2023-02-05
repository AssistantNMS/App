// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import './required_item.dart';

class Processor {
  String id;
  String time;
  bool isRefiner;
  String operation;
  RequiredItem output;
  List<RequiredItem> inputs;

  Processor({
    required this.id,
    required this.time,
    required this.isRefiner,
    required this.operation,
    required this.output,
    required this.inputs,
  });

  factory Processor.fromRawJson(String str, bool isRefiner) =>
      Processor.fromJson(json.decode(str), isRefiner);

  factory Processor.fromJson(Map<String, dynamic>? json, bool isRefiner) =>
      Processor(
        id: readStringSafe(json, 'Id'),
        time: readStringSafe(json, 'Time'),
        isRefiner: isRefiner,
        operation: readStringSafe(json, 'Operation'),
        output: RequiredItem.fromJson(json?["Output"]),
        inputs: readListSafe(
          json,
          'Inputs',
          (x) => RequiredItem.fromJson(x),
        ),
      );
}
