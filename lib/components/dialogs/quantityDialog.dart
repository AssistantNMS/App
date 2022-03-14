import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../components/dialogs/baseDialog.dart';

void showQuantityDialog(context, TextEditingController controller,
    {String title, Function onSuccess}) {
  List<DialogButton> buttons = List.empty(growable: true);
  buttons.add(DialogButton(
    child: Text(
      getTranslations().fromKey(LocaleKey.close),
      style: TextStyle(
        color: getTheme().getIsDark(context) ? Colors.black : Colors.white,
      ),
    ),
    onPressed: () => Navigator.of(context).pop(),
  ));
  buttons.add(DialogButton(
    child: Text(
      getTranslations().fromKey(LocaleKey.apply),
      style: TextStyle(
        color: getTheme().getIsDark(context) ? Colors.black : Colors.white,
      ),
    ),
    onPressed: () {
      onSuccess(controller.text);
      Navigator.of(context).pop();
    },
  ));

  List<int> amounts = [1, 2, 3, 5, 10, 25];
  List<InputChip> inputs = List.empty(growable: true);
  for (int amount in amounts) {
    inputs.add(
      InputChip(
        label: Text(
          amount.toString(),
          style: TextStyle(
            color: getTheme().getIsDark(context) ? Colors.black : Colors.white,
          ),
        ),
        backgroundColor: getTheme().getSecondaryColour(context),
        onPressed: () => onControllerTextChange(
          controller,
          amount.toString(),
        ),
      ),
    );
  }

  simpleWidgetDialog(
    context,
    title ?? getTranslations().fromKey(LocaleKey.quantity),
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: controller,
          style: const TextStyle(),
          autofocus: true,
          cursorColor: getTheme().getSecondaryColour(context),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: inputs),
      ],
    ),
    buttons: buttons,
  );
}

void onControllerTextChange(
    TextEditingController textEditController, String content) {
  textEditController
    ..text = content
    ..selection = const TextSelection.collapsed(offset: 0);
}
