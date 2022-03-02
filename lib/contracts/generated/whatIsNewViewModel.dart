// To parse this JSON data, do
//
//     final whatIsNewViewModel = whatIsNewViewModelFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

class WhatIsNewViewModel {
  String guid;
  String title;
  String description;
  bool isAndroid;
  bool isIos;
  bool isWebApp;
  bool isWeb;
  DateTime activeDate;

  WhatIsNewViewModel({
    this.guid,
    this.title,
    this.description,
    this.isAndroid,
    this.isIos,
    this.isWebApp,
    this.isWeb,
    this.activeDate,
  });

  factory WhatIsNewViewModel.fromRawJson(String str) =>
      WhatIsNewViewModel.fromJson(json.decode(str));

  factory WhatIsNewViewModel.fromJson(Map<String, dynamic> json) =>
      WhatIsNewViewModel(
        guid: json["guid"],
        title: json["title"],
        description: json["description"],
        isAndroid: json["isAndroid"],
        isIos: json["isIos"],
        isWebApp: json["isWebApp"],
        isWeb: json["isWeb"],
        activeDate: DateTime.parse(json["activeDate"]),
      );
}
