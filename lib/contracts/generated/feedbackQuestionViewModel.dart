// To parse this JSON data, do
//
//     final feedbackViewModel = feedbackViewModelFromJson(jsonString);
//https://app.quicktype.io/

import 'dart:convert';
import '../../contracts/enum/feedbackQuestionType.dart';

class FeedbackQuestionViewModel {
  String guid;
  String question;
  FeedbackQuestionType type;

  FeedbackQuestionViewModel({
    this.guid,
    this.question,
    this.type,
  });

  factory FeedbackQuestionViewModel.fromRawJson(String str) =>
      FeedbackQuestionViewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedbackQuestionViewModel.fromJson(Map<String, dynamic> json) =>
      FeedbackQuestionViewModel(
        guid: json["guid"],
        question: json["question"],
        type: FeedbackQuestionType
            .values[json["type"] != null ? json["type"] as int : 0],
      );

  Map<String, dynamic> toJson() => {
        "guid": guid,
        "question": question,
        "type": type,
      };
}
