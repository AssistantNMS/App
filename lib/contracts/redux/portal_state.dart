import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:meta/meta.dart';

import '../portal/portal_record.dart';

@immutable
class PortalState {
  final List<PortalRecord> portals;
  final List<String> availableTags;

  const PortalState({
    required this.portals,
    required this.availableTags,
  });

  factory PortalState.initial() {
    return PortalState(
        portals: List.empty(growable: true),
        availableTags: List.empty(growable: true));
  }

  PortalState copyWith({
    List<PortalRecord>? portals,
    List<String>? availableTags,
  }) {
    return PortalState(
        portals: portals ?? this.portals,
        availableTags: availableTags ?? this.availableTags);
  }

  factory PortalState.fromGoogleJson(String json) =>
      PortalState.fromJson(jsonDecode(json));

  factory PortalState.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PortalState.initial();
    try {
      return PortalState(
        portals: readListSafe<PortalRecord>(
          json,
          'portals',
          (p) => PortalRecord.fromJson(p),
        ).toList(),
        availableTags: readStringListSafe(json, 'availableTags').toList(),
      );
    } catch (exception) {
      return PortalState.initial();
    }
  }

  Map<String, dynamic> toJson() =>
      {'portals': portals, 'availableTags': availableTags};

  String toGoogleJson() => jsonEncode(toJson());
}
