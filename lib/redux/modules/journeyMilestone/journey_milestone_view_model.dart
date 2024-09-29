import 'package:redux/redux.dart';

import '../../../contracts/journey/stored_journey_milestone.dart';
import '../../../contracts/redux/app_state.dart';
import 'actions.dart';
import 'selector.dart';

class JourneyMilestoneViewModel {
  List<StoredJourneyMilestone> storedMilestones;

  Function(String journeyId, int journeyStatIndex) setMilestone;

  JourneyMilestoneViewModel({
    required this.storedMilestones,
    required this.setMilestone,
  });

  static JourneyMilestoneViewModel fromStore(Store<AppState> store) {
    return JourneyMilestoneViewModel(
      storedMilestones: getJourneyMilestones(store.state),
      setMilestone: (String journeyId, int journeyStatIndex) =>
          store.dispatch(SetMilestoneAction(journeyId, journeyStatIndex)),
    );
  }
}
