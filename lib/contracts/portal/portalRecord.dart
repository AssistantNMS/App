import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class PortalRecord {
  late String uuid;
  late String date;
  String? name;
  final List<int> codes;
  final List<String> tags;

  PortalRecord({
    String? uuid,
    this.name,
    String? date,
    required this.codes,
    required this.tags,
  }) {
    this.uuid = uuid ?? getNewGuid();
    this.date = date ?? DateTime.now().toString();
  }

  bool compareCodes(List<int> current) {
    bool isEqual = true;
    for (var codeIndex = 0; codeIndex < codes.length; codeIndex++) {
      if (codes[codeIndex] != current[codeIndex]) {
        isEqual = false;
        break;
      }
    }
    return isEqual;
  }

  PortalRecord copyWith({
    String? uuid,
    String? name,
    String? date,
    List<int>? codes,
    List<String>? tags,
  }) {
    return PortalRecord(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      date: date ?? this.date,
      codes: codes ?? this.codes,
      tags: tags ?? this.tags,
    );
  }

  factory PortalRecord.fromJson(Map<String, dynamic>? json) => PortalRecord(
        uuid: readStringSafe(json, 'uuid'),
        name: readStringSafe(json, 'name'),
        date: readStringSafe(json, 'date'),
        tags: readListSafe(json, 'tags', ((c) => c as String)),
        codes: readListSafe(json, 'codes', ((c) => c as int)),
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'date': date,
        'tags': tags,
        'codes': codes,
      };
}
