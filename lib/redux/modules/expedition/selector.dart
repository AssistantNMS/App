import '../../../contracts/redux/appState.dart';

List<String> getClaimedRewards(AppState state) =>
    state?.expeditionState?.claimedRewards ?? List.empty(growable: false);
