// To parse this JSON data, do
//
//     final friendCodeViewModel = friendCodeViewModelFromJson(jsonString);

import 'dart:convert';

class FriendCodeViewModel {
  FriendCodeViewModel({
    this.name,
    this.emailHash,
    this.platformType,
    this.code,
    this.dateSubmitted,
    this.dateVerified,
    this.sortRank,
  });

  String name;
  String emailHash;
  int platformType;
  String code;
  DateTime dateSubmitted;
  DateTime dateVerified;
  int sortRank;

  List<FriendCodeViewModel> friendCodeViewModelFromJson(String str) =>
      List<FriendCodeViewModel>.from(
          json.decode(str).map((x) => FriendCodeViewModel.fromJson(x)));

  factory FriendCodeViewModel.fromJson(Map<String, dynamic> json) =>
      FriendCodeViewModel(
        name: json["name"],
        emailHash: json["emailHash"],
        platformType: json["platformType"],
        code: json["code"],
        dateSubmitted: DateTime.parse(json["dateSubmitted"]),
        dateVerified: DateTime.parse(json["dateVerified"]),
        sortRank: json["sortRank"],
      );
}
