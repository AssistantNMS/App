import 'package:redux/redux.dart';

import '../../../contracts/redux/app_state.dart';
import '../setting/selector.dart';
import 'actions.dart';
import 'selector.dart';

class ExpeditionViewModel {
  final bool useAltGlyphs;
  List<String> claimedRewards;

  void Function(String) addToClaimedRewards;
  void Function(String) removeFromClaimedRewards;

  ExpeditionViewModel({
    required this.useAltGlyphs,
    required this.claimedRewards,
    required this.addToClaimedRewards,
    required this.removeFromClaimedRewards,
  });

  static ExpeditionViewModel fromStore(Store<AppState> store) {
    return ExpeditionViewModel(
      useAltGlyphs: getUseAltGlyphs(store.state),
      claimedRewards: getClaimedRewards(store.state),
      addToClaimedRewards: (String rewardId) =>
          store.dispatch(AddToClaimedRewardsAction(rewardId)),
      removeFromClaimedRewards: (String rewardId) =>
          store.dispatch(RemoveClaimedRewardAction(rewardId)),
    );
  }
}
