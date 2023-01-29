import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../helpers/shortcutHelper.dart';

Widget simpleGenericPageScaffold<T>(
  context, {
  required String title,
  Widget? body,
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
  String? title,
  Widget? drawer,
  PreferredSizeWidget? appBar,
  bool showHomeAction = true,
  bool showBackAction = true,
  bool showShortcutLinks = false,
  List<ActionItem>? actions,
  Widget? body,
  Widget? fab,
  FloatingActionButtonLocation? fabLocation,
}) {
  return getBaseWidget().appScaffold(
    context,
    appBar: appBar ??
        getBaseWidget().appBarForSubPage(
          context,
          title: Text(title ?? getTranslations().fromKey(LocaleKey.unknown)),
          actions: actions,
          showHomeAction: showHomeAction,
          showBackAction: showBackAction,
          shortcutActions: (showShortcutLinks) //
              ? getShortcutActions(context)
              : null,
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
  AsyncSnapshot<T> snapshot, {
  required Widget Function(BuildContext context, AsyncSnapshot<T> snapshot)
      body,
  bool showShortcutLinks = false,
  List<ActionItem>? additionalShortcutLinks,
  Widget? floatingActionButton,
}) {
  List<ActionItem> localAdditionalShortcuts = (additionalShortcutLinks ?? []);
  return getBaseWidget().appScaffold(
    context,
    appBar: getBaseWidget().appBarForSubPage(
      context,
      title: Text(title),
      showHomeAction: true,
      shortcutActions:
          (showShortcutLinks || localAdditionalShortcuts.isNotEmpty)
              ? getShortcutActions(
                  context,
                  additionalShortcutLinks: localAdditionalShortcuts,
                )
              : null,
    ),
    body: body(context, snapshot),
    floatingActionButton: floatingActionButton,
  );
}
