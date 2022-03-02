// To parse this JSON data, do
//
//     final weekendMission = weekendMissionFromJson(jsonString);

import 'dart:convert';

class WeekendMission {
  WeekendMission({
    this.id,
    this.titles,
    this.subtitles,
    this.descriptions,
    this.stages,
  });

  String id;
  List<String> titles;
  List<String> subtitles;
  List<String> descriptions;
  List<WeekendStage> stages;

  factory WeekendMission.fromRawJson(String str) =>
      WeekendMission.fromJson(json.decode(str));

  factory WeekendMission.fromJson(Map<String, dynamic> json) => WeekendMission(
        id: json["Id"],
        stages: List<WeekendStage>.from(
            json["Stages"].map((x) => WeekendStage.fromJson(x))),
        titles: json["Titles"] == null
            ? List.empty(growable: true)
            : List<String>.from(json["Titles"].map((x) => x)),
        subtitles: json["Subtitles"] == null
            ? List.empty(growable: true)
            : List<String>.from(json["Subtitles"].map((x) => x)),
        descriptions: json["Descriptions"] == null
            ? List.empty(growable: true)
            : List<String>.from(json["Descriptions"].map((x) => x)),
      );
}

class WeekendStage {
  WeekendStage({
    this.level,
    this.npcMessage,
    this.appId,
    this.iterationAppId,
    this.quantity,
    this.portalAddress,
    this.npcMessageFlows,
    this.portalMessageFlows,
  });

  int level;
  String npcMessage;
  String appId;
  String iterationAppId;
  int quantity;
  String portalAddress;
  MessageFlow npcMessageFlows;
  MessageFlow portalMessageFlows;

  factory WeekendStage.fromRawJson(String str) =>
      WeekendStage.fromJson(json.decode(str));

  factory WeekendStage.fromJson(Map<String, dynamic> json) => WeekendStage(
        level: json["Level"],
        npcMessage: json["NpcMessage"],
        appId: json["AppId"],
        iterationAppId: json["IterationAppId"],
        quantity: json["Quantity"],
        portalAddress: json["PortalAddress"],
        npcMessageFlows: MessageFlow.fromJson(json["NpcMessageFlows"]),
        portalMessageFlows: MessageFlow.fromJson(json["PortalMessageFlows"]),
      );
}

class Option {
  Option({
    this.name,
    this.ifSelected,
  });

  String name;
  MessageFlow ifSelected;

  factory Option.fromRawJson(String str) => Option.fromJson(json.decode(str));

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        name: json["Name"],
        ifSelected: MessageFlow.fromJson(json["IfSelected"]),
      );
}

class MessageFlow {
  MessageFlow({
    this.incomingMessages,
    this.options,
  });

  List<String> incomingMessages;
  List<Option> options;

  factory MessageFlow.fromRawJson(String str) =>
      MessageFlow.fromJson(json.decode(str));

  factory MessageFlow.fromJson(Map<String, dynamic> json) => MessageFlow(
        incomingMessages:
            List<String>.from(json["IncomingMessages"].map((x) => x)),
        options:
            List<Option>.from(json["Options"].map((x) => Option.fromJson(x))),
      );
}
