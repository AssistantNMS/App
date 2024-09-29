import 'package:redux/redux.dart';

import '../../../contracts/journey/stored_journey_milestone.dart';
import '../../../contracts/faction/stored_faction_mission.dart';
import '../../../contracts/redux/journey_milestone_state.dart';
import 'actions.dart';

final journeyMilestoneReducer = combineReducers<JourneyMilestoneState>([
  TypedReducer<JourneyMilestoneState, SetMilestoneAction>(_setMilestoneAction),
  TypedReducer<JourneyMilestoneState, SetFaction>(_setFactionAction),
]);

JourneyMilestoneState _setMilestoneAction(
    JourneyMilestoneState state, SetMilestoneAction action) {
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
