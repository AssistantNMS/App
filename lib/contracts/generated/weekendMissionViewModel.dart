import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class WeekendMissionViewModel {
  String seasonId;
  int level;
  bool isConfirmedByCaptSteve;
  bool isConfirmedByAssistantNms;
  String? captainSteveVideoUrl;
  DateTime activeDate;

  WeekendMissionViewModel({
    required this.seasonId,
    required this.level,
    required this.isConfirmedByCaptSteve,
    required this.isConfirmedByAssistantNms,
    required this.captainSteveVideoUrl,
    required this.activeDate,
  });

  factory WeekendMissionViewModel.fromRawJson(String str) =>
      WeekendMissionViewModel.fromJson(json.decode(str));

  factory WeekendMissionViewModel.fromJson(Map<String, dynamic>? json) =>
      WeekendMissionViewModel(
        seasonId: readStringSafe(json, 'seasonId'),
        level: readIntSafe(json, 'level'),
        isConfirmedByCaptSteve: readBoolSafe(json, 'isConfirmedByCaptSteve'),
        isConfirmedByAssistantNms:
            readBoolSafe(json, 'isConfirmedByAssistantNms'),
        captainSteveVideoUrl: readStringSafe(json, 'captainSteveVideoUrl'),
        activeDate: readDateSafe(json, 'activeDate'),
      );
}
