// To parse this JSON data, do
//
//     final feedbackViewModel = feedbackViewModelFromJson(jsonString);
//https://app.quicktype.io/

import 'dart:convert';
import './feedbackQuestionViewModel.dart';

class FeedbackViewModel {
  String guid;
  String name;
  DateTime createdOn;
  List<FeedbackQuestionViewModel> questions;

  FeedbackViewModel({
    this.guid,
    this.name,
    this.createdOn,
    this.questions,
  });

  factory FeedbackViewModel.fromRawJson(String str) =>
      FeedbackViewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedbackViewModel.fromJson(Map<String, dynamic> json) =>
      FeedbackViewModel(
        guid: json["guid"],
        name: json["name"],
        createdOn: DateTime.parse(json["createdOn"]),
        questions: List<FeedbackQuestionViewModel>.from(json["questions"]
            .map((x) => FeedbackQuestionViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "guid": guid,
        "name": name,
        "createdOn": createdOn.toIso8601String(),
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}
