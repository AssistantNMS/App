// To parse this JSON data, do
//
//     final nmsfmTrackData = nmsfmTrackDataFromMap(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../enum/nmsfmTrackType.dart';

class NmsfmTrackData {
  NmsfmTrackData({
    this.title,
    this.artist,
    this.type,
    this.runtimeInSeconds,
  });

  String title;
  String artist;
  NmsfmTrackType type;
  int runtimeInSeconds;

  factory NmsfmTrackData.fromRawJson(String str) =>
      NmsfmTrackData.fromJson(json.decode(str));

  factory NmsfmTrackData.fromJson(Map<String, dynamic> json) => NmsfmTrackData(
        title: readStringSafe(json, 'title'),
        artist: readStringSafe(json, 'artist'),
        type: nmsfmTrackTypeValues.map[readIntSafe(json, 'type').toString()],
        runtimeInSeconds: readIntSafe(json, 'runtimeInSeconds'),
      );
}
