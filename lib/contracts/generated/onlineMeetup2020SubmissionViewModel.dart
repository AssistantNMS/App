// To parse this JSON data, do
//
//     final onlineMeetup2020SubmissionViewModel = onlineMeetup2020SubmissionViewModelFromJson(jsonString);

import 'dart:convert';

class OnlineMeetup2020SubmissionViewModel {
  OnlineMeetup2020SubmissionViewModel({
    this.guid,
    this.userName,
    this.userImage,
    this.text,
    this.imageUrl,
    this.externalUrl,
    this.sortRank,
  });

  String guid;
  String userName;
  String userImage;
  String text;
  String imageUrl;
  String externalUrl;
  int sortRank;

  factory OnlineMeetup2020SubmissionViewModel.fromRawJson(String str) =>
      OnlineMeetup2020SubmissionViewModel.fromJson(json.decode(str));

  factory OnlineMeetup2020SubmissionViewModel.fromJson(
          Map<String, dynamic> json) =>
      OnlineMeetup2020SubmissionViewModel(
        guid: json["guid"],
        userName: json["userName"],
        userImage: json["userImage"],
        text: json["text"],
        imageUrl: json["imageUrl"],
        externalUrl: json["externalUrl"],
        sortRank: json["sortRank"],
      );
}
