import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:redux/redux.dart';

import '../../../contracts/redux/appState.dart';
import 'actions.dart';
import 'drawerSettingsViewModel.dart';
import 'selector.dart';

class CustomMenuSettingsViewModel {
  final bool isPatron;
  final List<LocaleKey> menuOrder;
  final bool dontShowSpoilerAlert;
  final bool showFestiveBackground;
  final void Function(List<LocaleKey>) setCustomMenuOrder;

  CustomMenuSettingsViewModel({
    this.isPatron,
    this.menuOrder,
    this.dontShowSpoilerAlert,
    this.showFestiveBackground,
    this.setCustomMenuOrder,
  });

  static CustomMenuSettingsViewModel fromStore(Store<AppState> store) =>
      CustomMenuSettingsViewModel(
        isPatron: getIsPatron(store.state),
        menuOrder: getCustomMenuOrder(store.state),
        dontShowSpoilerAlert: getDontShowSpoilerAlert(store.state),
        setCustomMenuOrder: (List<LocaleKey> newOrder) =>
            store.dispatch(SetCustomMenuOrder(newOrder)),
      );

  DrawerSettingsViewModel toDrawerViewModel() => DrawerSettingsViewModel(
        isPatron: this.isPatron,
        dontShowSpoilerAlert: this.dontShowSpoilerAlert,
      );
}
