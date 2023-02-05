// To parse this JSON data, do
//
//     final onlineMeetup2020SubmissionViewModel = onlineMeetup2020SubmissionViewModelFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class OnlineMeetup2020SubmissionViewModel {
  OnlineMeetup2020SubmissionViewModel({
    required this.guid,
    required this.userName,
    required this.userImage,
    required this.text,
    required this.imageUrl,
    required this.externalUrl,
    required this.sortRank,
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
          Map<String, dynamic>? json) =>
      OnlineMeetup2020SubmissionViewModel(
        guid: readStringSafe(json, 'guid'),
        userName: readStringSafe(json, 'userName'),
        userImage: readStringSafe(json, 'userImage'),
        text: readStringSafe(json, 'text'),
        imageUrl: readStringSafe(json, 'imageUrl'),
        externalUrl: readStringSafe(json, 'externalUrl'),
        sortRank: readIntSafe(json, 'sortRank'),
      );
}
