import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide AdaptiveAppScaffold;
import 'package:flutter/material.dart';

import '../../components/adaptive/app_scaffold.dart';

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
      AdaptiveAppScaffold(
        appBar: appBar,
        body: body,
        builder: builder,
        drawer: drawer,
        bottomNavigationBar: bottomNavigationBar,
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
      AdaptiveAppBar(
        title: title,
        actions: actions,
        leading: leading,
        bottom: bottom,
      );

  @override
  PreferredSizeWidget appBarForSubPage(
    BuildContext context, {
    Widget? title,
    List<ActionItem>? actions,
    List<ActionItem>? shortcutActions,
    bool showHomeAction = false,
    bool showBackAction = true,
  }) =>
      AdaptiveAppBarForSubPage(
        title,
        actions ?? [],
        showBackAction,
        showHomeAction,
        shortcutActions ?? [],
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
    Color? backgroundColor,
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

  @override
  Widget adaptiveCheckbox({
    Key? key,
    required bool value,
    required void Function(bool newValue) onChanged,
    Color? activeColor,
  }) =>
      AdaptiveCheckbox(
        key: key,
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
      );

  @override
  Widget customDivider() => isWeb
      ? Divider(thickness: .5, color: Colors.grey[800])
      : Divider(color: Colors.grey[800]);
}
