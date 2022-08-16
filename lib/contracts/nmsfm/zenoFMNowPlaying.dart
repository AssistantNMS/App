// To parse this JSON data, do
//
//     final zenoFmNowPlaying = zenoFmNowPlayingFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/helpers/jsonHelper.dart';

class ZenoFmNowPlaying {
  ZenoFmNowPlaying({
    // this.album,
    // this.sku,
    // this.thumb,
    this.artist,
    this.title,
    // this.show,
    // this.buyUrls,
    // this.infoUrls,
    // this.duration,
    // this.guid,
  });

  // final dynamic album;
  // final dynamic sku;
  // final String thumb;
  final String artist;
  final String title;
  // final Show show;
  // final String buyUrls;
  // final String infoUrls;
  // final int duration;
  // final dynamic guid;

  factory ZenoFmNowPlaying.fromRawJson(String str) =>
      ZenoFmNowPlaying.fromJson(json.decode(str));

  factory ZenoFmNowPlaying.fromJson(Map<String, dynamic> json) =>
      ZenoFmNowPlaying(
        // album: json["album"],
        // sku: json["sku"],
        // thumb: json["thumb"],
        artist: readStringSafe(json, 'artist'),
        title: readStringSafe(json, 'title'),
        // show: Show.fromJson(json["show"]),
        // buyUrls: json["buy_urls"],
        // infoUrls: json["info_urls"],
        // duration: json["duration"],
        // guid: json["guid"],
      );

  factory ZenoFmNowPlaying.defaultObj() => ZenoFmNowPlaying(
        artist: '',
        title: '',
      );
}
