// To parse this JSON data, do
//
//     final friendCodeViewModel = friendCodeViewModelFromJson(jsonString);

import 'dart:convert';

class AddFriendCodeViewModel {
  AddFriendCodeViewModel({
    this.name,
    this.email,
    this.platformType,
    this.code,
    this.languageCode,
  });

  String name;
  String email;
  int platformType;
  String code;
  String languageCode;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Email': email,
        'PlatformType': platformType,
        'Code': code,
        'LanguageCode': languageCode,
      };
}
