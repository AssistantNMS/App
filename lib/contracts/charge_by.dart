import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class ChargeBy {
  ChargeBy({
    required this.id,
    required this.value,
  });

  String id;
  int value;

  factory ChargeBy.fromRawJson(String str) =>
      ChargeBy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChargeBy.fromJson(Map<String, dynamic>? json) => ChargeBy(
        id: readStringSafe(json, 'Id'),
        value: readIntSafe(json, 'Value'),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Value": value,
      };
}
