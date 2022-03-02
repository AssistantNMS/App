// To parse this JSON data, do
//
//     final alienPuzzle = alienPuzzleFromMap(jsonString);

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'alienPuzzleRaceType.dart';
import 'alienPuzzleType.dart';

class AlienPuzzle {
  AlienPuzzle({
    this.id,
    this.type,
    this.race,
    this.isFactory,
    this.number,
    this.incomingMessages,
    this.options,
  });

  String id;
  AlienPuzzleType type;
  AlienPuzzleRaceType race;
  bool isFactory;
  int number;
  List<String> incomingMessages;
  List<Option> options;

  factory AlienPuzzle.fromJson(Map<String, dynamic> json) => AlienPuzzle(
        id: readStringSafe(json, 'Id'),
        type: alienPuzzleTypeValues.map[readStringSafe(json, 'Type')],
        race: alienPuzzleRaceTypeValues.map[readStringSafe(json, 'Race')],
        isFactory: readBoolSafe(json, 'IsFactory'),
        number: readIntSafe(json, 'Number'),
        incomingMessages: readListSafe(
            json, 'IncomingMessages', (dynamic innerJson) => innerJson),
        options: readListSafe(
            json, 'Options', (dynamic innerJson) => Option.fromJson(innerJson)),
      );
}

class Option {
  Option({
    this.name,
    this.text,
    this.interactionId,
    this.rewardIds,
  });

  String name;
  String text;
  String interactionId;
  List<String> rewardIds;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        name: readStringSafe(json, 'Name'),
        text: readStringSafe(json, 'Text'),
        interactionId: readStringSafe(json, 'InteractionId'),
        rewardIds:
            readListSafe(json, 'RewardIds', (dynamic innerJson) => innerJson),
      );
}
