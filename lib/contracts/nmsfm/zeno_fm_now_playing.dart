// To parse this JSON data, do
//
//     final zenoFmNowPlaying = zenoFmNowPlayingFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class ZenoFmNowPlaying {
  final String artist;
  final String title;

  ZenoFmNowPlaying({
    required this.artist,
    required this.title,
  });

  factory ZenoFmNowPlaying.fromRawJson(String str) =>
      ZenoFmNowPlaying.fromJson(json.decode(str));

  factory ZenoFmNowPlaying.fromJson(Map<String, dynamic>? json) =>
      ZenoFmNowPlaying(
        artist: readStringSafe(json, 'artist'),
        title: readStringSafe(json, 'title'),
      );

  factory ZenoFmNowPlaying.defaultObj() => ZenoFmNowPlaying(
        artist: '',
        title: '',
      );
}
