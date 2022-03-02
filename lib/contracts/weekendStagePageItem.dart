// To parse this JSON data, do
//
//     final weekendMission = weekendMissionFromJson(jsonString);

import 'weekendMission.dart';
import 'genericPageItem.dart';

class WeekendStagePageItem {
  WeekendStagePageItem({
    this.titles,
    this.subtitles,
    this.descriptions,
    this.season,
    this.stage,
    this.cost,
    this.iteration,
    this.isConfirmedByCaptSteve,
    this.isConfirmedByAssistantNms,
    this.captainSteveVideoUrl,
  });

  List<String> titles;
  List<String> subtitles;
  List<String> descriptions;
  String season;
  WeekendStage stage;
  GenericPageItem cost;
  GenericPageItem iteration;
  bool isConfirmedByCaptSteve;
  bool isConfirmedByAssistantNms;
  String captainSteveVideoUrl;
}
