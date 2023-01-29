import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../contracts/redux/app_state.dart';
import '../../redux/modules/setting/settingViewModel.dart';

class AdaptiveAppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget Function(BuildContext scaffoldContext)? builder;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AdaptiveAppScaffold({
    Key? key,
    this.appBar,
    this.body,
    this.builder,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingViewModel>(
      converter: (store) => SettingViewModel.fromStore(store),
      rebuildOnChange: false,
      builder: (_, viewModel) {
        Widget customBody = builder != null
            ? Builder(builder: (inner) => builder!(inner))
            : body!;

        BackgroundType bgType = BackgroundType.notSet;
        if (viewModel.showFestiveBackground) {
          if (isValentinesPeriod()) bgType = BackgroundType.valentines;
          if (isChristmasPeriod()) bgType = BackgroundType.christmas;
        }

        return WillPopScope(
          onWillPop: () => getNavigation().navigateBackOrHomeAsync(context),
          child: Scaffold(
            appBar: appBar,
            body: animateWidgetIn(
              child: BackgroundWrapper(
                key: Key(bgType.toString()),
                backgroundType: bgType,
                body: customBody,
              ),
            ),
            drawer: drawer,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
          ),
        );
      },
    );
  }
}
