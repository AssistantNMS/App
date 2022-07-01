import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

@immutable
class TitleState {
  final List<String> owned;
  final bool hideCompleted;

  const TitleState({
    this.owned,
    this.hideCompleted,
  });

  factory TitleState.initial() {
    return TitleState(
      owned: List.empty(growable: true),
      hideCompleted: false,
    );
  }

  TitleState copyWith({
    List<String> owned,
    bool hideCompleted,
  }) {
    return TitleState(
      owned: owned ?? this.owned,
      hideCompleted: hideCompleted ?? this.hideCompleted,
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
          hideCompleted: readBoolSafe(json, 'hideCompleted'));
    } catch (exception) {
      return TitleState.initial();
    }
  }

  Map<String, dynamic> toJson() => {
        'owned': owned,
        'hideCompleted': hideCompleted,
      };
}
