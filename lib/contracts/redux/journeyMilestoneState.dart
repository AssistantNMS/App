import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../faction/storedFactionMission.dart';
import '../journey/storedJourneyMilestone.dart';

@immutable
class JourneyMilestoneState {
  final List<StoredJourneyMilestone> storedMilestones;
  final List<StoredFactionMission> storedFactions;

  const JourneyMilestoneState({
    this.storedMilestones,
    this.storedFactions,
  });

  factory JourneyMilestoneState.initial() {
    return JourneyMilestoneState(
      storedMilestones: List.empty(),
      storedFactions: List.empty(),
    );
  }

  JourneyMilestoneState copyWith({
    List<StoredJourneyMilestone> storedMilestones,
    List<StoredFactionMission> storedFactions,
  }) {
    return JourneyMilestoneState(
      storedMilestones: storedMilestones ?? List.empty(),
      storedFactions: storedFactions ?? List.empty(),
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
        storedFactions: readListSafe<StoredFactionMission>(
            json,
            'storedFactions',
            (dynamic innerJson) => StoredFactionMission.fromJson(innerJson)),
      );
    } catch (exception) {
      return JourneyMilestoneState.initial();
    }
  }

  Map<String, dynamic> toJson() => {
        'storedMilestones': storedMilestones,
        'storedFactions': storedFactions,
      };
}
