import 'dart:convert';

import 'package:assistantapps_flutter_common/helpers/jsonHelper.dart';

class GuildMission {
  GuildMission({
    this.id,
    this.objective,
    this.titles,
    this.subtitles,
    this.descriptions,
    this.type,
    this.difficulty,
    this.minRank,
    this.factions,
    this.icon,
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

  factory GuildMission.fromJson(Map<String, dynamic> json) => //
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
