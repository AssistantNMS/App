// To parse this JSON data, do
//
//     final alienPuzzle = alienPuzzleFromMap(jsonString);

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'alien_puzzle_race_type.dart';
import 'alien_puzzle_type.dart';

class AlienPuzzle {
  String id;
  AlienPuzzleType type;
  AlienPuzzleRaceType race;
  bool isFactory;
  int number;
  List<String> incomingMessages;
  List<Option> options;

  AlienPuzzle({
    required this.id,
    required this.type,
    required this.race,
    required this.isFactory,
    required this.number,
    required this.incomingMessages,
    required this.options,
  });

  factory AlienPuzzle.fromJson(Map<String, dynamic>? json) => AlienPuzzle(
        id: readStringSafe(json, 'Id'),
        type: alienPuzzleTypeValues.map[readStringSafe(json, 'Type')] ??
            AlienPuzzleType.Unknown,
        race: alienPuzzleRaceTypeValues.map[readStringSafe(json, 'Race')] ??
            AlienPuzzleRaceType.None,
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
    required this.name,
    required this.text,
    required this.interactionId,
    required this.rewardIds,
  });

  String name;
  String text;
  String interactionId;
  List<String> rewardIds;

  factory Option.fromJson(Map<String, dynamic>? json) => Option(
        name: readStringSafe(json, 'Name'),
        text: readStringSafe(json, 'Text'),
        interactionId: readStringSafe(json, 'InteractionId'),
        rewardIds:
            readListSafe(json, 'RewardIds', (dynamic innerJson) => innerJson),
      );
}
