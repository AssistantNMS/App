import '../base/persist_to_storage.dart';

class SetMilestonAction extends PersistToStorage {
  final String journeyId;
  final int journeyStatIndex;
  SetMilestonAction(this.journeyId, this.journeyStatIndex);
}

class SetFaction extends PersistToStorage {
  final String missionId;
  final int missionTierIndex;
  SetFaction(this.missionId, this.missionTierIndex);
}
