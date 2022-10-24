// To parse this JSON data, do
//
//     final release = releaseFromJson(jsonString);

import 'dart:convert';

class ReleaseNote {
  String name;
  String description;
  String link;
  bool isPc;
  bool isPs4;
  bool isPs5;
  bool isXb1;
  bool isXbsx;
  bool isNsw;

  ReleaseNote({
    this.name,
    this.description,
    this.link,
    this.isPc,
    this.isPs4,
    this.isPs5,
    this.isXb1,
    this.isXbsx,
    this.isNsw,
  });

  factory ReleaseNote.fromRawJson(String str) =>
      ReleaseNote.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReleaseNote.fromJson(Map<String, dynamic> json) => ReleaseNote(
        name: json["name"],
        description: json["description"],
        link: json["link"],
        isPc: json["isPc"],
        isPs4: json["isPs4"],
        isPs5: json["isPs5"],
        isXb1: json["isXb1"],
        isXbsx: json["isXbsx"],
        isNsw: json["isNsw"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "link": link,
        "isPc": isPc,
        "isPs4": isPs4,
        "isPs5": isPs5,
        "isXb1": isXb1,
        "isXbsx": isXbsx,
        "isNsw": isNsw,
      };
}
