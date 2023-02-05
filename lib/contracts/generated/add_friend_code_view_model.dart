// To parse this JSON data, do
//
//     final friendCodeViewModel = friendCodeViewModelFromJson(jsonString);

import 'dart:convert';

class AddFriendCodeViewModel {
  AddFriendCodeViewModel({
    required this.name,
    required this.email,
    required this.platformType,
    required this.code,
    required this.languageCode,
  });

  String name;
  String email;
  int platformType;
  String code;
  String languageCode;

  factory AddFriendCodeViewModel.initial() => AddFriendCodeViewModel(
        name: '',
        email: '',
        platformType: 0,
        code: '',
        languageCode: '',
      );

  AddFriendCodeViewModel copyWith({
    String? name,
    String? email,
    int? platformType,
    String? code,
    String? languageCode,
  }) {
    return AddFriendCodeViewModel(
      name: name ?? this.name,
      email: email ?? this.email,
      platformType: platformType ?? this.platformType,
      code: code ?? this.code,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Email': email,
        'PlatformType': platformType,
        'Code': code,
        'LanguageCode': languageCode,
      };
}
