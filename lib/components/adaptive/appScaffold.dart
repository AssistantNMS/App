import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../contracts/redux/appState.dart';
import '../../redux/modules/setting/settingViewModel.dart';

Widget adaptiveAppScaffold(
  BuildContext context, {
  required PreferredSizeWidget appBar,
  Widget? body,
  Widget Function(BuildContext scaffoldContext)? builder,
  Widget? drawer,
  Widget? floatingActionButton,
  FloatingActionButtonLocation? floatingActionButtonLocation,
}) =>
    StoreConnector<AppState, SettingViewModel>(
      converter: (store) => SettingViewModel.fromStore(store),
      rebuildOnChange: false,
      builder: (_, viewModel) {
        Widget? customBody = builder != null
            ? Builder(builder: (inner) => builder(inner))
            : body;
        return _androidScaffold(
          context,
          appBar: appBar,
          body: customBody!,
          drawer: drawer,
          viewModel: viewModel,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
        );
      },
    );

Widget _androidScaffold(
  BuildContext context, {
  required PreferredSizeWidget appBar,
  required Widget body,
  Widget? drawer,
  required SettingViewModel viewModel,
  Widget? floatingActionButton,
  FloatingActionButtonLocation? floatingActionButtonLocation,
}) {
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
          body: body,
        ),
      ),
      drawer: drawer,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    ),
  );
}
