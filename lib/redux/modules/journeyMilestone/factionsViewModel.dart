import 'package:redux/redux.dart';

import '../../../contracts/faction/storedFactionMission.dart';
import '../../../contracts/redux/appState.dart';
import 'actions.dart';
import 'selector.dart';

class FactionsViewModel {
  List<StoredFactionMission> storedFactions;

  Function(String missionId, int missionTierIndex) setFaction;

  FactionsViewModel({
    this.storedFactions,
    this.setFaction,
  });

  static FactionsViewModel fromStore(Store<AppState> store) {
    return FactionsViewModel(
      storedFactions: getFactions(store.state),
      setFaction: (String missionId, int missionTierIndex) =>
          store.dispatch(SetFaction(missionId, missionTierIndex)),
    );
  }
}
