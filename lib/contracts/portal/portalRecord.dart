import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class PortalRecord {
  String uuid;
  String date;
  String name;
  final List<int> codes;
  final List<String> tags;

  PortalRecord({String uuid, this.name, String date, this.codes, this.tags}) {
    this.uuid = uuid ?? getNewGuid();
    this.date = date ?? DateTime.now().toString();
  }

  bool compareCodes(List<int> current) {
    bool isEqual = true;
    for (var codeIndex = 0; codeIndex < codes.length; codeIndex++) {
      if (this.codes[codeIndex] != current[codeIndex]) {
        isEqual = false;
        break;
      }
    }
    return isEqual;
  }

  PortalRecord copyWith(
      {String uuid,
      String name,
      String date,
      List<int> codes,
      List<String> tags}) {
    return PortalRecord(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      date: date ?? this.date,
      codes: codes ?? this.codes,
      tags: tags ?? this.tags,
    );
  }

  factory PortalRecord.fromJson(Map<String, dynamic> json) => PortalRecord(
        uuid: json["uuid"],
        name: json["name"],
        date: json["date"],
        tags: json["tags"] != null
            ? (json["tags"] as List).map((c) => c as String).toList()
            : List.empty(growable: true),
        codes: json["codes"] != null
            ? (json["codes"] as List).map((c) => c as int).toList()
            : List.empty(growable: true),
      );

  Map<String, dynamic> toJson() => {
        'uuid': this.uuid,
        'name': this.name,
        'date': this.date,
        'tags': this.tags,
        'codes': this.codes,
      };
}
