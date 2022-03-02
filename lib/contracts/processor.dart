// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
// https://app.quicktype.io/

import './requiredItem.dart';

class Processor {
  String id;
  String time;
  bool isRefiner;
  String operation;
  RequiredItem output;
  List<RequiredItem> inputs;

  Processor({
    this.id,
    this.time,
    this.isRefiner,
    this.operation,
    this.output,
    this.inputs,
  });

  factory Processor.fromJson(Map<String, dynamic> json, bool isRefiner) =>
      Processor(
        id: json["Id"] as String,
        time: json["Time"] as String,
        isRefiner: isRefiner,
        operation: json["Operation"] as String,
        output: RequiredItem.fromJson(json["Output"]),
        inputs: List<RequiredItem>.from(
            json["Inputs"].map((x) => RequiredItem.fromJson(x))),
      );
}
