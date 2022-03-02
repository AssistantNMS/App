import 'dart:convert';

class FeedbackQuestionAnsweredViewModel {
  String feedbackQuestionGuid;
  String answer;

  FeedbackQuestionAnsweredViewModel({
    this.feedbackQuestionGuid,
    this.answer,
  });

  factory FeedbackQuestionAnsweredViewModel.fromRawJson(String str) =>
      FeedbackQuestionAnsweredViewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeedbackQuestionAnsweredViewModel.fromJson(
          Map<String, dynamic> json) =>
      FeedbackQuestionAnsweredViewModel(
        feedbackQuestionGuid: json["feedbackQuestionGuid"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "feedbackQuestionGuid": feedbackQuestionGuid,
        "answer": answer,
      };
}
