import '../../../contracts/redux/app_state.dart';

List<String> getClaimedRewards(AppState state) =>
    state.expeditionState.claimedRewards;
