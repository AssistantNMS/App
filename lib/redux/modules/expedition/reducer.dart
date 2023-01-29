import '../../../contracts/redux/expedition_state.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

final expeditionReducer = combineReducers<ExpeditionState>([
  TypedReducer<ExpeditionState, AddToClaimedRewardsAction>(
      _addToClaimedRewardsAction),
  TypedReducer<ExpeditionState, RemoveClaimedRewardAction>(
      _removeClaimedRewardAction),
]);

ExpeditionState _addToClaimedRewardsAction(
    ExpeditionState state, AddToClaimedRewardsAction action) {
  List<String> newClaimedRewards = [...state.claimedRewards, action.rewardId];
  return state.copyWith(claimedRewards: newClaimedRewards);
}

ExpeditionState _removeClaimedRewardAction(
    ExpeditionState state, RemoveClaimedRewardAction action) {
  List<String> newClaimedRewards = List.empty(growable: true);
  for (String claimedReward in state.claimedRewards) {
    if (claimedReward == action.rewardId) continue;
    newClaimedRewards.add(claimedReward);
  }
  return state.copyWith(claimedRewards: newClaimedRewards);
}
