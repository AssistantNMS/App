import 'dart:convert';

class WeekendMissionViewModel {
  String seasonId;
  int level;
  bool isConfirmedByCaptSteve;
  bool isConfirmedByAssistantNms;
  String captainSteveVideoUrl;
  DateTime activeDate;

  WeekendMissionViewModel({
    this.seasonId,
    this.level,
    this.isConfirmedByCaptSteve,
    this.isConfirmedByAssistantNms,
    this.captainSteveVideoUrl,
    this.activeDate,
  });

  factory WeekendMissionViewModel.fromRawJson(String str) =>
      WeekendMissionViewModel.fromJson(json.decode(str));

  factory WeekendMissionViewModel.fromJson(Map<String, dynamic> json) =>
      WeekendMissionViewModel(
        seasonId: json["seasonId"],
        level: json["level"],
        isConfirmedByCaptSteve: json["isConfirmedByCaptSteve"],
        isConfirmedByAssistantNms: json["isConfirmedByAssistantNms"],
        captainSteveVideoUrl: json["captainSteveVideoUrl"],
        activeDate: DateTime.parse(json["activeDate"]),
      );
}
