import 'package:redux/redux.dart';

import '../../../contracts/journey/storedJourneyMilestone.dart';
import '../../../contracts/redux/appState.dart';
import 'actions.dart';
import 'selector.dart';

class JourneyMilestoneViewModel {
  List<StoredJourneyMilestone> storedMilestones;

  Function(String journeyId, int journeyStatIndex) setMilestone;

  JourneyMilestoneViewModel({
    this.storedMilestones,
    this.setMilestone,
  });

  static JourneyMilestoneViewModel fromStore(Store<AppState> store) {
    return JourneyMilestoneViewModel(
      storedMilestones: getJourneyMilestones(store.state),
      setMilestone: (String journeyId, int journeyStatIndex) =>
          store.dispatch(SetMilestonAction(journeyId, journeyStatIndex)),
    );
  }
}
