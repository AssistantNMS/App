import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../helpers/shortcutHelper.dart';

Widget simpleGenericPageScaffold<T>(
  context, {
  String title,
  Widget body,
}) {
  return getBaseWidget().appScaffold(
    context,
    appBar: getBaseWidget().appBarForSubPage(
      context,
      title: Text(title),
      showHomeAction: true,
    ),
    body: body,
  );
}

Widget basicGenericPageScaffold<T>(
  context, {
  String title,
  Widget drawer,
  Widget appBar,
  bool showHomeAction = true,
  bool showBackAction = true,
  List<ActionItem> actions,
  Widget body,
  Widget fab,
  FloatingActionButtonLocation fabLocation,
}) {
  return getBaseWidget().appScaffold(
    context,
    appBar: appBar ??
        getBaseWidget().appBarForSubPage(
          context,
          title: Text(title),
          actions: actions,
          showHomeAction: showHomeAction,
          showBackAction: showBackAction,
        ),
    drawer: drawer,
    body: body,
    floatingActionButton: fab,
    floatingActionButtonLocation: fabLocation,
  );
}

Widget genericPageScaffold<T>(
  context,
  String title,
  snapshot, {
  Widget Function(BuildContext context, AsyncSnapshot<T> snapshot) body,
  bool showShortcutLinks = false,
  List<ActionItem> additionalShortcutLinks,
  floatingActionButton,
}) {
  return getBaseWidget().appScaffold(
    context,
    appBar: getBaseWidget().appBarForSubPage(
      context,
      title: Text(title),
      showHomeAction: true,
      shortcutActions:
          (showShortcutLinks || (additionalShortcutLinks ?? []).isNotEmpty)
              ? getShortcutActions(context,
                  additionalShortcutLinks: additionalShortcutLinks)
              : null,
    ),
    body: body(context, snapshot),
    floatingActionButton: floatingActionButton,
  );
}
