import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

@immutable
class TitleState {
  final List<String> owned;

  TitleState({
    this.owned,
  });

  factory TitleState.initial() {
    return TitleState(
      owned: List.empty(growable: true),
    );
  }

  TitleState copyWith({
    List<String> owned,
  }) {
    return TitleState(
      owned: owned ?? List.empty(growable: true),
    );
  }

  factory TitleState.fromJson(Map<String, dynamic> json) {
    if (json == null) return TitleState.initial();
    try {
      return TitleState(
        owned: readListSafe<String>(
          json,
          'owned',
          (p) => p.toString(),
        ).toList(),
      );
    } catch (exception) {
      return TitleState.initial();
    }
  }

  Map<String, dynamic> toJson() => {
        'owned': owned,
      };
}
