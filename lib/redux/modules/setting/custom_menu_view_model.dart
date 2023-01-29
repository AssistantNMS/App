import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:redux/redux.dart';

import '../../../contracts/redux/app_state.dart';
import 'actions.dart';
import 'drawer_settings_view_model.dart';
import 'selector.dart';

class CustomMenuSettingsViewModel {
  final bool isPatron;
  final List<LocaleKey> menuOrder;
  final bool dontShowSpoilerAlert;
  final bool showFestiveBackground;
  final int customColumnCount;
  final void Function(List<LocaleKey>) setCustomMenuOrder;

  CustomMenuSettingsViewModel({
    required this.isPatron,
    required this.menuOrder,
    required this.dontShowSpoilerAlert,
    required this.showFestiveBackground,
    required this.customColumnCount,
    required this.setCustomMenuOrder,
  });

  static CustomMenuSettingsViewModel fromStore(Store<AppState> store) =>
      CustomMenuSettingsViewModel(
        isPatron: getIsPatron(store.state),
        menuOrder: getCustomMenuOrder(store.state),
        dontShowSpoilerAlert: getDontShowSpoilerAlert(store.state),
        showFestiveBackground: getShowFestiveBackground(store.state),
        customColumnCount: getCustomHomePageColumnCount(store.state),
        setCustomMenuOrder: (List<LocaleKey> newOrder) => store.dispatch(
          SetCustomMenuOrder(newOrder),
        ),
      );

  DrawerSettingsViewModel toDrawerViewModel() => DrawerSettingsViewModel(
        isPatron: isPatron,
        dontShowSpoilerAlert: dontShowSpoilerAlert,
      );
}
