// To parse this JSON data, do
//
//     final weekendMission = weekendMissionFromJson(jsonString);

import 'weekendMission.dart';
import 'genericPageItem.dart';

class WeekendStagePageItem {
  List<String> titles;
  List<String> subtitles;
  List<String> descriptions;
  String season;
  WeekendStage stage;
  GenericPageItem? cost;
  GenericPageItem? iteration;
  bool isConfirmedByCaptSteve;
  bool isConfirmedByAssistantNms;
  String? captainSteveVideoUrl;

  WeekendStagePageItem({
    required this.titles,
    required this.subtitles,
    required this.descriptions,
    required this.season,
    required this.stage,
    required this.cost,
    required this.iteration,
    required this.isConfirmedByCaptSteve,
    required this.isConfirmedByAssistantNms,
    this.captainSteveVideoUrl,
  });

  factory WeekendStagePageItem.initial() => WeekendStagePageItem(
        titles: [],
        subtitles: [],
        descriptions: [],
        season: '',
        stage: WeekendStage.fromRawJson('{}'),
        cost: GenericPageItem.fromJson(<String, dynamic>{}),
        iteration: GenericPageItem.fromJson(<String, dynamic>{}),
        isConfirmedByCaptSteve: false,
        isConfirmedByAssistantNms: false,
      );
}
