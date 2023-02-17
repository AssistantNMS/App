import '../base/persist_to_storage.dart';

class AddToClaimedRewardsAction extends PersistToStorage {
  final String rewardId;
  AddToClaimedRewardsAction(this.rewardId);
}

class RemoveClaimedRewardAction extends PersistToStorage {
  final String rewardId;
  RemoveClaimedRewardAction(this.rewardId);
}
