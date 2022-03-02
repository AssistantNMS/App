import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../journey/storedJourneyMilestone.dart';

@immutable
class JourneyMilestoneState {
  final List<StoredJourneyMilestone> storedMilestones;

  JourneyMilestoneState({
    this.storedMilestones,
  });

  factory JourneyMilestoneState.initial() {
    return JourneyMilestoneState(
      storedMilestones: List.empty(growable: true),
    );
  }

  JourneyMilestoneState copyWith({
    List<StoredJourneyMilestone> storedMilestones,
  }) {
    return JourneyMilestoneState(
      storedMilestones: storedMilestones ?? List.empty(growable: true),
    );
  }

  factory JourneyMilestoneState.fromJson(Map<String, dynamic> json) {
    if (json == null) return JourneyMilestoneState.initial();
    try {
      return JourneyMilestoneState(
        storedMilestones: readListSafe<StoredJourneyMilestone>(
            json,
            'storedMilestones',
            (dynamic innerJson) => StoredJourneyMilestone.fromJson(innerJson)),
      );
    } catch (exception) {
      return JourneyMilestoneState.initial();
    }
  }

  Map<String, dynamic> toJson() => {
        'storedMilestones': storedMilestones,
      };
}
