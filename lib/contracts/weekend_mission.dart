// To parse this JSON data, do
//
//     final weekendMission = weekendMissionFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class WeekendMission {
  WeekendMission({
    required this.id,
    required this.titles,
    required this.subtitles,
    required this.descriptions,
    required this.stages,
  });

  String id;
  List<String> titles;
  List<String> subtitles;
  List<String> descriptions;
  List<WeekendStage> stages;

  factory WeekendMission.fromRawJson(String str) =>
      WeekendMission.fromJson(json.decode(str));

  factory WeekendMission.fromJson(Map<String, dynamic>? json) => WeekendMission(
        id: readStringSafe(json, 'Id'),
        stages: readListSafe(
          json,
          'Stages',
          (x) => WeekendStage.fromJson(x),
        ),
        titles: readListSafe(json, 'Titles', (x) => x.toString()),
        subtitles: readListSafe(json, 'Subtitles', (x) => x.toString()),
        descriptions: readListSafe(json, 'Descriptions', (x) => x.toString()),
      );
}

class WeekendStage {
  WeekendStage({
    required this.level,
    required this.npcMessage,
    required this.appId,
    required this.iterationAppId,
    required this.quantity,
    required this.portalAddress,
    required this.npcMessageFlows,
    required this.portalMessageFlows,
  });

  int level;
  String npcMessage;
  String appId;
  String iterationAppId;
  int quantity;
  String? portalAddress;
  MessageFlow? npcMessageFlows;
  MessageFlow? portalMessageFlows;

  factory WeekendStage.fromRawJson(String str) =>
      WeekendStage.fromJson(json.decode(str));

  factory WeekendStage.fromJson(Map<String, dynamic>? json) => WeekendStage(
        level: readIntSafe(json, 'Level'),
        npcMessage: readStringSafe(json, 'NpcMessage'),
        appId: readStringSafe(json, 'AppId'),
        iterationAppId: readStringSafe(json, 'IterationAppId'),
        quantity: readIntSafe(json, 'Quantity'),
        portalAddress: readStringSafe(json, 'PortalAddress'),
        npcMessageFlows: MessageFlow.fromJson(json?["NpcMessageFlows"]),
        portalMessageFlows: MessageFlow.fromJson(json?["PortalMessageFlows"]),
      );
}

class Option {
  Option({
    required this.name,
    required this.ifSelected,
  });

  String name;
  MessageFlow ifSelected;

  factory Option.fromRawJson(String str) => Option.fromJson(json.decode(str));

  factory Option.fromJson(Map<String, dynamic>? json) => Option(
        name: readStringSafe(json, 'Name'),
        ifSelected: MessageFlow.fromJson(json?["IfSelected"]),
      );
}

class MessageFlow {
  MessageFlow({
    required this.incomingMessages,
    required this.options,
  });

  List<String> incomingMessages;
  List<Option>? options;

  factory MessageFlow.fromRawJson(String str) =>
      MessageFlow.fromJson(json.decode(str));

  factory MessageFlow.fromJson(Map<String, dynamic>? json) => MessageFlow(
        incomingMessages: readListSafe(
          json,
          'IncomingMessages',
          (x) => x.toString(),
        ),
        options: readListSafe(
          json,
          'Options',
          (x) => Option.fromJson(x),
        ),
      );
}
