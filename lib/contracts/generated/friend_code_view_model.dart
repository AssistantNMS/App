// To parse this JSON data, do
//
//     final friendCodeViewModel = friendCodeViewModelFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class FriendCodeViewModel {
  FriendCodeViewModel({
    required this.name,
    required this.emailHash,
    required this.platformType,
    required this.code,
    required this.dateSubmitted,
    required this.dateVerified,
    required this.sortRank,
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
        json.decode(str).map(
              (x) => FriendCodeViewModel.fromJson(x),
            ),
      );

  factory FriendCodeViewModel.fromJson(Map<String, dynamic>? json) =>
      FriendCodeViewModel(
        name: readStringSafe(json, 'name'),
        emailHash: readStringSafe(json, 'emailHash'),
        platformType: readIntSafe(json, 'platformType'),
        code: readStringSafe(json, 'code'),
        dateSubmitted: readDateSafe(json, 'dateSubmitted'),
        dateVerified: readDateSafe(json, 'dateVerified'),
        sortRank: readIntSafe(json, 'sortRank'),
      );
}
