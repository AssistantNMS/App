import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appBar.dart';
import 'shortcutActionButton.dart';

class AppBarForSubPage extends StatelessWidget
    implements PreferredSizeWidget, ObstructingPreferredSizeWidget {
  final Widget title;
  final List<ActionItem> actions;
  final List<ActionItem> shortcutActions;
  final bool showHomeAction;
  final bool showBackAction;
  @override
  final Size preferredSize;
  final dynamic bottom;
  final Color backgroundColor;
  static const double kMinInteractiveDimensionCupertino = 44.0;

  AppBarForSubPage(this.title, this.actions, this.showHomeAction,
      this.showBackAction, this.shortcutActions,
      {Key key, this.bottom, this.backgroundColor})
      : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      _appBarForAndroid(context, title, actions, shortcutActions);

  Widget _appBarForAndroid(context, Widget title, List<ActionItem> actions,
      List<ActionItem> shortcutActions) {
    List<Widget> actionWidgets = List.empty(growable: true);
    if (shortcutActions != null && shortcutActions.isNotEmpty) {
      actionWidgets.add(shortcutActionButton(context, shortcutActions));
    }
    actionWidgets.addAll(actionItemToAndroidAction(actions));
    return adaptiveAppBar(context, title, actionWidgets,
        leading: showBackAction
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async =>
                    await getNavigation().navigateBackOrHomeAsync(context),
              )
            : null);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) => true;
}

Widget adaptiveAppBarForSubPageHelper(context,
    {Widget title,
    List<ActionItem> actions,
    bool showHomeAction = false,
    bool showBackAction = true,
    List<ActionItem> shortcutActions}) {
  if (actions == null || actions.isEmpty) {
    actions = List.empty(growable: true);
  }

  if (showHomeAction) {
    actions.add(ActionItem(
        icon: Icons.home,
        onPressed: () async =>
            await getNavigation().navigateHomeAsync(context)));
  }
  return AppBarForSubPage(
      title, actions, showHomeAction, showBackAction, shortcutActions);
}
