// To parse this JSON data, do
//
//     final feedbackAnsweredViewModel = feedbackAnsweredViewModelFromJson(jsonString);

import 'dart:convert';

import './feedbackQuestionAnsweredViewModel.dart';
import '../../contracts/enum/appType.dart';

class FeedbackAnsweredViewModel {
  String feedbackGuid;
  AppType appType;
  List<FeedbackQuestionAnsweredViewModel> answers;

  FeedbackAnsweredViewModel({
    this.feedbackGuid,
    this.appType,
    this.answers,
  });

  factory FeedbackAnsweredViewModel.fromRawJson(String str) =>
      FeedbackAnsweredViewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedbackAnsweredViewModel.fromJson(Map<String, dynamic> json) =>
      FeedbackAnsweredViewModel(
        feedbackGuid: json["feedbackGuid"],
        appType: appTypeValues
            .map[json["appType"] != null ? json["appType"] as int : 0],
        answers: List<FeedbackQuestionAnsweredViewModel>.from(json["answers"]
            .map((x) => FeedbackQuestionAnsweredViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "feedbackGuid": feedbackGuid,
        "appType": int.parse(appTypeValues.reverse[appType]),
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
      };
}
