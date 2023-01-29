// To parse this JSON data, do
//
//     final whatIsNewViewModel = whatIsNewViewModelFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

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
    required this.guid,
    required this.title,
    required this.description,
    required this.isAndroid,
    required this.isIos,
    required this.isWebApp,
    required this.isWeb,
    required this.activeDate,
  });

  factory WhatIsNewViewModel.fromRawJson(String str) =>
      WhatIsNewViewModel.fromJson(json.decode(str));

  factory WhatIsNewViewModel.fromJson(Map<String, dynamic>? json) =>
      WhatIsNewViewModel(
        guid: readStringSafe(json, 'guid'),
        title: readStringSafe(json, 'title'),
        description: readStringSafe(json, 'description'),
        isAndroid: readBoolSafe(json, 'isAndroid'),
        isIos: readBoolSafe(json, 'isIos'),
        isWebApp: readBoolSafe(json, 'isWebApp'),
        isWeb: readBoolSafe(json, 'isWeb'),
        activeDate: readDateSafe(json, 'activeDate'),
      );
}
