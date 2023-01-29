import 'package:redux/redux.dart';

import '../../../contracts/redux/app_state.dart';
import 'actions.dart';
import 'selector.dart';

class CommunityMissionSettingViewModel {
  final int lastPlatformIndex;

  final Function(int) setPlatformIndex;

  CommunityMissionSettingViewModel({
    required this.lastPlatformIndex,
    required this.setPlatformIndex,
  });

  static CommunityMissionSettingViewModel fromStore(Store<AppState> store) =>
      CommunityMissionSettingViewModel(
        lastPlatformIndex: getLastPlatformIndex(store.state),
        setPlatformIndex: (int lastPlatformIndex) =>
            store.dispatch(SetLastPlatformIndex(lastPlatformIndex)),
      );
}
