import 'package:redux/redux.dart';

import '../../../contracts/redux/app_state.dart';
import 'selector.dart';

class DrawerSettingsViewModel {
  final bool dontShowSpoilerAlert;
  final bool isPatron;

  DrawerSettingsViewModel({
    required this.dontShowSpoilerAlert,
    required this.isPatron,
  });

  static DrawerSettingsViewModel fromStore(Store<AppState> store) =>
      DrawerSettingsViewModel(
        dontShowSpoilerAlert: getDontShowSpoilerAlert(store.state),
        isPatron: getIsPatron(store.state),
      );
}
