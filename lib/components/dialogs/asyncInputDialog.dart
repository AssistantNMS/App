import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<String> asyncInputDialog(BuildContext context, String title,
    {String defaultText, List<Widget> actions, TextInputType inputType}) async {
  String output = '';
  List<TextInputFormatter> inputFormatters = inputType == TextInputType.number
      ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
      : null;
  var alertResult = await Alert(
    context: context,
    title: title,
    style: AlertStyle(
      titleStyle: TextStyle(
        color: getTheme().getIsDark(context) ? Colors.white : Colors.black,
      ),
    ),
    content: Row(
      children: <Widget>[
        Expanded(
            child: TextField(
          autofocus: true,
          controller: TextEditingController(text: defaultText),
          keyboardType: inputType == null ? TextInputType.text : null,
          inputFormatters: inputFormatters,
          onChanged: (value) {
            output = value;
          },
        ))
      ],
    ),
    buttons: [
      DialogButton(
        child: Text(
          getTranslations().fromKey(LocaleKey.close),
          style: TextStyle(color: getTheme().buttonForegroundColour(context)),
        ),
        onPressed: () => getNavigation().pop(context, false),
      ),
      DialogButton(
        child: Text(
          getTranslations().fromKey(LocaleKey.apply),
          style: TextStyle(color: getTheme().buttonForegroundColour(context)),
        ),
        onPressed: () => getNavigation().pop(context, true),
      ),
    ],
  ).show(); // This is ugly, I know. Don't touch though, here be Dragons
  return alertResult ? output : null;
}
