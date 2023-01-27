import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/adaptive/appBar.dart';
import '../../components/adaptive/appBarForSubPage.dart';
import '../../components/adaptive/appScaffold.dart';

class BaseWidgetService implements IBaseWidgetService {
  @override
  Widget appScaffold(
    BuildContext context, {
    required PreferredSizeWidget appBar,
    Widget? body,
    Widget Function(BuildContext scaffoldContext)? builder,
    Widget? drawer,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
  }) =>
      adaptiveAppScaffold(
        context,
        appBar: appBar,
        body: body,
        builder: builder,
        drawer: drawer,
        // bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      );

  @override
  Widget appBar(
    BuildContext context,
    Widget title,
    List<Widget> actions, {
    Widget? leading,
    PreferredSizeWidget? bottom,
  }) =>
      adaptiveAppBar(context, title, actions, leading: leading, bottom: bottom);

  @override
  PreferredSizeWidget appBarForSubPage(
    BuildContext context, {
    Widget? title,
    List<ActionItem>? actions,
    List<ActionItem>? shortcutActions,
    bool showHomeAction = false,
    bool showBackAction = true,
  }) =>
      adaptiveAppBarForSubPageHelper(
        context,
        title: title,
        actions: actions,
        shortcutActions: shortcutActions,
        showBackAction: showBackAction,
        showHomeAction: showHomeAction,
      );

  @override
  Widget appChip({
    Key? key,
    String? text,
    Widget? label,
    TextStyle? style,
    EdgeInsets? labelPadding,
    double? elevation,
    EdgeInsets? padding,
    Color? shadowColor,
    Icon? deleteIcon,
    void Function()? onDeleted,
    void Function()? onTap,
    Color backgroundColor = Colors.white,
  }) =>
      AdaptiveChip(
        key: key,
        text: text,
        label: label,
        style: style,
        labelPadding: labelPadding,
        elevation: elevation,
        padding: padding,
        shadowColor: shadowColor,
        deleteIcon: deleteIcon,
        onDeleted: onDeleted,
        onTap: onTap,
        backgroundColor: backgroundColor,
      );
}
