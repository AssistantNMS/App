import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class GuildMission {
  GuildMission({
    required this.id,
    required this.objective,
    required this.titles,
    required this.subtitles,
    required this.descriptions,
    required this.type,
    required this.difficulty,
    required this.minRank,
    required this.factions,
    required this.icon,
  });

  String id;
  String objective;
  List<String> titles;
  List<String> subtitles;
  List<String> descriptions;
  String type;
  String difficulty;
  int minRank;
  List<String> factions;
  String icon;

  factory GuildMission.fromRawJson(String str) =>
      GuildMission.fromJson(json.decode(str));

  factory GuildMission.fromJson(Map<String, dynamic>? json) => //
      GuildMission(
        id: readStringSafe(json, 'Id'),
        objective: readStringSafe(json, 'Objective'),
        titles: readListSafe(json, 'Titles', (x) => x.toString()),
        subtitles: readListSafe(json, 'Subtitles', (x) => x.toString()),
        descriptions: readListSafe(json, 'Descriptions', (x) => x.toString()),
        type: readStringSafe(json, 'Type'),
        difficulty: readStringSafe(json, 'Difficulty'),
        minRank: readIntSafe(json, 'MinRank'),
        factions: readListSafe(json, 'Factions', (x) => x.toString()),
        icon: readStringSafe(json, 'Icon'),
      );
}
