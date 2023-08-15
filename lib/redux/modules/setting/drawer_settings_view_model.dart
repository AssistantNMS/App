import 'package:redux/redux.dart';

import '../../../contracts/enum/homepage_type.dart';
import '../../../contracts/redux/app_state.dart';
import 'selector.dart';

class DrawerSettingsViewModel {
  final bool dontShowSpoilerAlert;
  final bool isPatron;
  final HomepageType homepageType;

  DrawerSettingsViewModel({
    required this.dontShowSpoilerAlert,
    required this.isPatron,
    required this.homepageType,
  });

  static DrawerSettingsViewModel fromStore(Store<AppState> store) =>
      DrawerSettingsViewModel(
        dontShowSpoilerAlert: getDontShowSpoilerAlert(store.state),
        isPatron: getIsPatron(store.state),
        homepageType: getHomepageType(store.state),
      );
}
