import 'package:redux/redux.dart';

import '../../../contracts/faction/stored_faction_mission.dart';
import '../../../contracts/redux/app_state.dart';
import 'actions.dart';
import 'selector.dart';

class FactionsViewModel {
  List<StoredFactionMission> storedFactions;

  Function(String missionId, int missionTierIndex) setFaction;

  FactionsViewModel({
    required this.storedFactions,
    required this.setFaction,
  });

  static FactionsViewModel fromStore(Store<AppState> store) {
    return FactionsViewModel(
      storedFactions: getFactions(store.state),
      setFaction: (String missionId, int missionTierIndex) =>
          store.dispatch(SetFaction(missionId, missionTierIndex)),
    );
  }
}
