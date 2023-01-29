import 'package:assistantnms_app/contracts/faction/stored_faction_mission.dart';

import '../../../contracts/journey/storedJourneyMilestone.dart';
import 'package:redux/redux.dart';

import '../../../contracts/redux/journeyMilestoneState.dart';
import 'actions.dart';

final journeyMilestoneReducer = combineReducers<JourneyMilestoneState>([
  TypedReducer<JourneyMilestoneState, SetMilestonAction>(_setMilestonAction),
  TypedReducer<JourneyMilestoneState, SetFaction>(_setFactionAction),
]);

JourneyMilestoneState _setMilestonAction(
    JourneyMilestoneState state, SetMilestonAction action) {
  bool itemExists = false;
  StoredJourneyMilestone itemToAdd = StoredJourneyMilestone(
    journeyId: action.journeyId,
    journeyStatIndex: action.journeyStatIndex,
  );
  List<StoredJourneyMilestone> newItems =
      state.storedMilestones.map((StoredJourneyMilestone storedM) {
    if (storedM.journeyId == action.journeyId) {
      itemExists = true;
      return itemToAdd;
    }
    return storedM;
  }).toList();

  if (itemExists == false) {
    newItems.add(itemToAdd);
  }

  return state.copyWith(storedMilestones: newItems);
}

JourneyMilestoneState _setFactionAction(
    JourneyMilestoneState state, SetFaction action) {
  bool itemExists = false;
  StoredFactionMission itemToAdd = StoredFactionMission(
    missionId: action.missionId,
    missionTierIndex: action.missionTierIndex,
  );
  List<StoredFactionMission> newItems =
      state.storedFactions.map((StoredFactionMission storedF) {
    if (storedF.missionId == action.missionId) {
      itemExists = true;
      return itemToAdd;
    }
    return storedF;
  }).toList();

  if (itemExists == false) {
    newItems.add(itemToAdd);
  }

  return state.copyWith(storedFactions: newItems);
}
