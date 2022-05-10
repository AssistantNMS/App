import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void simpleDialog(context, String title, String contentString,
    {List<DialogButton> buttons}) {
  simpleWidgetDialog(
    context,
    title,
    _getBodyText(contentString),
    buttons: buttons,
  );
}

void simpleWidgetDialog(BuildContext context, String title, Widget content,
    {List<DialogButton> buttons, Function() closeFunction}) {
  Alert(
    context: context,
    title: title,
    style: AlertStyle(
      titleStyle: TextStyle(
        color: getTheme().getIsDark(context) ? Colors.white : Colors.black,
      ),
    ),
    content: content,
    buttons: buttons,
    closeFunction: closeFunction,
  ).show();
}

void nmsShowSimpleHelpDialog(context, String title, String helpContent,
    {List<DialogButton> buttons}) {
  simpleWidgetDialog(
    context,
    title,
    Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [_getBodyText(helpContent)]),
    buttons: [simpleDialogCloseButton(context)],
  );
}

Widget _getBodyText(String bodyText) {
  return Text(
    bodyText,
    style: const TextStyle(fontSize: 14),
    textAlign: TextAlign.center,
  );
}

Widget simpleDialogCloseButton(context, {Function onTap}) => DialogButton(
      child: Text(
        getTranslations().fromKey(LocaleKey.close),
        style: TextStyle(
          color: getTheme().getIsDark(context) ? Colors.black : Colors.white,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        if (onTap != null) onTap();
      },
    );

Widget simpleDialogPositiveButton(context, {LocaleKey title, Function onTap}) =>
    DialogButton(
      child: Text(
        getTranslations().fromKey(title ?? LocaleKey.apply),
        style: TextStyle(
          color: getTheme().getIsDark(context) ? Colors.black : Colors.white,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        if (onTap != null) onTap();
      },
    );
