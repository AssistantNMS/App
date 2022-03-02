import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../components/dialogs/baseDialog.dart';
import '../../components/starRating.dart';

class DialogService implements IDialogService {
  //
  void showSimpleDialog(context, String title, Widget content,
      {List<Widget> buttons}) {
    Alert(
      context: context,
      title: title,
      style: AlertStyle(
        titleStyle: TextStyle(
          color: getTheme().getIsDark(context) ? Colors.white : Colors.black,
        ),
      ),
      content: content,
      buttons: buttons as List<DialogButton>,
    ).show();
  }

  void showSimpleHelpDialog(context, String title, String helpContent,
      {List<Widget> buttons}) {
    nmsShowSimpleHelpDialog(
      context,
      title,
      helpContent,
      buttons: [simpleDialogCloseButton(context)],
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

  Widget simpleDialogPositiveButton(context,
          {LocaleKey title, Function onTap}) =>
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

  void showOptionsDialog(context, String title, List<DropdownOption> options,
      {String selectedValue = '', Function(String value) onSuccess}) {
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

    var tempOnChange = (String value) {
      if (onSuccess != null) onSuccess(value);
      Navigator.of(context).pop();
    };

    showSimpleDialog(
      context,
      title ?? getTranslations().fromKey(LocaleKey.quantity),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: options
            .map((opt) => genericListTile(
                  context,
                  leadingImage: null,
                  name: opt.title,
                  onTap: () => tempOnChange(opt.value),
                ))
            .toList(),
      ),
      buttons: buttons,
    );
  }

  void showQuantityDialog(context, TextEditingController controller,
      {String title, Function(String) onSuccess}) {
    void onControllerTextChange(
        TextEditingController textEditController, String content) {
      textEditController
        ..text = content
        ..selection = TextSelection.collapsed(offset: 0);
    }

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
    for (var amount in amounts) {
      inputs.add(
        InputChip(
          label: Text(
            amount.toString(),
            style: TextStyle(
              color:
                  getTheme().getIsDark(context) ? Colors.black : Colors.white,
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

    showSimpleDialog(
      context,
      title ?? getTranslations().fromKey(LocaleKey.quantity),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: controller,
            style: TextStyle(),
            autofocus: true,
            cursorColor: getTheme().getSecondaryColour(context),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: inputs)
        ],
      ),
      buttons: buttons,
    );
  }

  void showStarDialog(context, String title,
      {int currentRating = 0, Function(int) onSuccess}) {
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

    showSimpleDialog(
      context,
      title,
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          starRating(context, currentRating, size: 64, onTap: (int value) {
            onSuccess(value);
            Navigator.of(context).pop();
          })
        ],
      ),
      buttons: buttons,
    );
  }

  Future<String> asyncInputDialog(BuildContext context, String title,
      {String defaultText,
      List<Widget> actions,
      TextInputType inputType}) async {
    String output = '';
    List<TextInputFormatter> inputFormatters = inputType == TextInputType.number
        ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
        : null;
    var alertResult = await Alert(
      context: context,
      title: title,
      closeFunction: () {},
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
            controller: new TextEditingController(text: defaultText),
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
          child: Text(getTranslations().fromKey(LocaleKey.close)),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        DialogButton(
          child: Text(getTranslations().fromKey(LocaleKey.apply)),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ).show(); // This is ugly, I know. Don't touch though, here be Dragons
    return alertResult ? output : null;
  }
}
