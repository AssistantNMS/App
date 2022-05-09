import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/components/adaptive/windowsTitleBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../contracts/redux/appState.dart';
import '../../redux/modules/setting/settingViewModel.dart';

Widget adaptiveAppScaffold(
  BuildContext context, {
  @required Widget appBar,
  Widget body,
  Widget Function(BuildContext scaffoldContext) builder,
  Widget drawer,
  Widget floatingActionButton,
  FloatingActionButtonLocation floatingActionButtonLocation,
}) =>
    StoreConnector<AppState, SettingViewModel>(
      converter: (store) => SettingViewModel.fromStore(store),
      rebuildOnChange: false,
      builder: (_, viewModel) {
        Widget customBody = builder != null
            ? Builder(builder: (inner) => builder(inner))
            : body;
        return _androidScaffold(
          context,
          appBar: appBar,
          body: customBody,
          drawer: drawer,
          viewModel: viewModel,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
        );
      },
    );

Widget _androidScaffold(
  BuildContext context, {
  @required PreferredSizeWidget appBar,
  Widget body,
  Widget drawer,
  SettingViewModel viewModel,
  Widget floatingActionButton,
  FloatingActionButtonLocation floatingActionButtonLocation,
}) {
  BackgroundType bgType = BackgroundType.NotSet;
  if (viewModel.showFestiveBackground) {
    if (isValentinesPeriod()) bgType = BackgroundType.Valentines;
    if (isChristmasPeriod()) bgType = BackgroundType.Christmas;
  }

  return WillPopScope(
    onWillPop: () => getNavigation().navigateBackOrHomeAsync(context),
    child: Scaffold(
      appBar: WindowsTitleBar('Assistant for No Man\'s Sky'),
      body: Scaffold(
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
    ),
  );
}
