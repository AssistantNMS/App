import 'dart:convert';

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
        id: json?["Id"],
        value: json?["Value"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Value": value,
      };
}
