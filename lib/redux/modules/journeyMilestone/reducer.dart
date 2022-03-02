import '../../../contracts/journey/storedJourneyMilestone.dart';
import 'package:redux/redux.dart';

import '../../../contracts/redux/journeyMilestoneState.dart';
import 'actions.dart';

final journeyMilestoneReducer = combineReducers<JourneyMilestoneState>([
  TypedReducer<JourneyMilestoneState, SetMilestonAction>(_setMilestonAction),
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
