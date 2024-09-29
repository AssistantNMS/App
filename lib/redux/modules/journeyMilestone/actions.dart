import '../base/persist_to_storage.dart';

class SetMilestoneAction extends PersistToStorage {
  final String journeyId;
  final int journeyStatIndex;
  SetMilestoneAction(this.journeyId, this.journeyStatIndex);
}

class SetFaction extends PersistToStorage {
  final String missionId;
  final int missionTierIndex;
  SetFaction(this.missionId, this.missionTierIndex);
}
