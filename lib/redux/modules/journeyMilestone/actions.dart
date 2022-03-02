import '../base/persistToStorage.dart';

class SetMilestonAction extends PersistToStorage {
  final String journeyId;
  final int journeyStatIndex;
  SetMilestonAction(this.journeyId, this.journeyStatIndex);
}
