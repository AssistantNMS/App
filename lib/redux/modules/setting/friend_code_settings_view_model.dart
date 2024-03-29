import 'package:redux/redux.dart';

import '../../../contracts/redux/app_state.dart';
import 'actions.dart';
import 'selector.dart';

class FriendCodeSettingsViewModel {
  final int lastPlatformIndex;
  final String selectedLanguage;

  final Function(int) setPlatformIndex;

  FriendCodeSettingsViewModel({
    required this.lastPlatformIndex,
    required this.selectedLanguage,
    required this.setPlatformIndex,
  });

  static FriendCodeSettingsViewModel fromStore(Store<AppState> store) =>
      FriendCodeSettingsViewModel(
        lastPlatformIndex: getLastPlatformIndex(store.state),
        selectedLanguage: getSelectedLanguage(store.state),
        setPlatformIndex: (int lastPlatformIndex) =>
            store.dispatch(SetLastPlatformIndex(lastPlatformIndex)),
      );
}
