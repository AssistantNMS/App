// To parse this JSON data, do
//
//     final eggTrait = eggTraitFromJson(jsonString);

import 'dart:convert';

import 'package:assistantapps_flutter_common/helpers/jsonHelper.dart';

import './platform_control_mapping.dart';

class ControlMappingList {
  ControlMappingList({
    required this.win,
    required this.psn,
    required this.xbx,
    required this.nsw,
  });

  List<PlatformControlMapping> win;
  List<PlatformControlMapping> psn;
  List<PlatformControlMapping> xbx;
  List<PlatformControlMapping> nsw;

  List<PlatformControlMapping> getPlatformControlsFromIndex(int platformIndex) {
    // if (platformIndex == 0) return win;
    if (platformIndex == 1) return psn;
    if (platformIndex == 2) return xbx;
    if (platformIndex == 3) return nsw;

    return win;
  }

  factory ControlMappingList.fromRawJson(String str) =>
      ControlMappingList.fromJson(json.decode(str));

  factory ControlMappingList.fromJson(Map<String, dynamic>? json) =>
      ControlMappingList(
        win: readListSafe(
          json,
          "Win",
          (dynamic innerJson) => PlatformControlMapping.fromJson(innerJson),
        ),
        psn: readListSafe(
          json,
          "Psn",
          (dynamic innerJson) => PlatformControlMapping.fromJson(innerJson),
        ),
        xbx: readListSafe(
          json,
          "Xbx",
          (dynamic innerJson) => PlatformControlMapping.fromJson(innerJson),
        ),
        nsw: readListSafe(
          json,
          "Nsw",
          (dynamic innerJson) => PlatformControlMapping.fromJson(innerJson),
        ),
      );
}
