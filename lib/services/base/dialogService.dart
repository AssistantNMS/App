import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/starRating.dart';

class DialogService implements IDialogService {
  //
  @override
  void showSimpleDialog(
    context,
    String title,
    Widget content, {
    List<Widget> Function(BuildContext) buttonBuilder,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogCtx) => AlertDialog(
        title: Text(title),
        // style: AlertStyle(
        //   titleStyle: TextStyle(
        //     color: getTheme().getIsDark(context) ? Colors.white : Colors.black,
        //   ),
        // ),
        content: content,
        actions: (buttonBuilder == null) ? [] : buttonBuilder(dialogCtx),
      ),
    );
  }

  @override
  void showSimpleHelpDialog(
    context,
    String title,
    String helpContent, {
    List<Widget> Function(BuildContext) buttonBuilder,
  }) {
    showSimpleDialog(
      context,
      title,
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            helpContent,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          )
        ],
      ),
      buttonBuilder: (BuildContext innerCtx) => (buttonBuilder == null)
          ? [simpleDialogCloseButton(innerCtx)]
          : buttonBuilder(innerCtx),
    );
  }

  @override
  Widget simpleDialogCloseButton(
    context, {
    Function onTap,
  }) =>
      MaterialButton(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(getTranslations().fromKey(LocaleKey.close)),
        ),
        textColor: getTheme().getPrimaryColour(context),
        onPressed: () {
          getNavigation().pop(context);
          if (onTap != null) onTap();
        },
      );

  @override
  Widget simpleDialogPositiveButton(
    context, {
    LocaleKey title,
    Function onTap,
  }) =>
      MaterialButton(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(getTranslations().fromKey(title ?? LocaleKey.apply)),
        ),
        textColor: getTheme().getPrimaryColour(context),
        onPressed: () {
          if (onTap != null) onTap();
        },
      );

  @override
  void showOptionsDialog(
    context,
    String title,
    List<DropdownOption> options, {
    String selectedValue = '',
    Function(BuildContext ctx, String value) onSuccess,
  }) {
    void Function(BuildContext dialogCtx, String value) tempOnChange;
    tempOnChange = (BuildContext dialogCtx, String value) {
      if (onSuccess != null) onSuccess(dialogCtx, value);
      getNavigation().pop(dialogCtx);
    };

    showDialog(
      context: context,
      builder: (BuildContext dialogCtx) => AlertDialog(
        title: Text(title ?? getTranslations().fromKey(LocaleKey.quantity)),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: options
              .map(
                (opt) => genericListTile(
                  dialogCtx,
                  leadingImage: opt.icon,
                  name: opt.title,
                  onTap: () => tempOnChange(dialogCtx, opt.value),
                ),
              )
              .toList(),
        ),
        actions: [
          simpleDialogCloseButton(dialogCtx),
        ],
      ),
    );
  }

  @override
  void showQuantityDialog(
    context,
    TextEditingController controller, {
    String title,
    Function(BuildContext ctx, String) onSuccess,
  }) {
    void onControllerTextChange(
      TextEditingController textEditController,
      String content,
    ) {
      textEditController
        ..text = content
        ..selection = const TextSelection.collapsed(offset: 0);
    }

    List<int> amounts = [1, 2, 3, 5, 10, 25];
    List<InputChip> inputs = List.empty(growable: true);
    for (int amount in amounts) {
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
            style: const TextStyle(),
            autofocus: true,
            cursorColor: getTheme().getSecondaryColour(context),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          Wrap(alignment: WrapAlignment.spaceEvenly, children: inputs),
        ],
      ),
      buttonBuilder: (BuildContext buttonCtx) => [
        simpleDialogCloseButton(buttonCtx),
        simpleDialogPositiveButton(
          buttonCtx,
          onTap: () {
            getNavigation().pop(buttonCtx);
            onSuccess(buttonCtx, controller.text);
          },
        ),
      ],
    );
  }

  @override
  void showStarDialog(
    context,
    String title, {
    int currentRating = 0,
    Function(BuildContext ctx, int) onSuccess,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogCtx) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            starRating(
              context,
              currentRating,
              size: 64,
              onTap: (int value) {
                onSuccess(dialogCtx, value);
                getNavigation().pop(dialogCtx);
              },
            ),
          ],
        ),
        // actions: [
        //   simpleDialogCloseButton(dialogCtx),
        // ],
      ),
    );
  }

  @override
  Future<String> asyncInputDialog(
    BuildContext context,
    String title, {
    String defaultText,
    List<Widget> Function(BuildContext) buttonBuilder,
    TextInputType inputType,
  }) async {
    String output = '';
    List<TextInputFormatter> inputFormatters = inputType == TextInputType.number
        ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
        : null;

    await showDialog<String>(
      context: context,
      builder: (BuildContext dialogCtx) => AlertDialog(
        title: Text(title),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                controller: TextEditingController(text: defaultText),
                keyboardType: inputType == null ? TextInputType.text : null,
                inputFormatters: inputFormatters,
                onChanged: (value) {
                  output = value;
                },
              ),
            )
          ],
        ),
        actions: (buttonBuilder == null)
            ? [
                simpleDialogCloseButton(dialogCtx),
                simpleDialogPositiveButton(
                  dialogCtx,
                  onTap: () {
                    getNavigation().pop(dialogCtx);
                  },
                ),
              ]
            : buttonBuilder(dialogCtx),
      ),
    );

    if (output == null) return '';
    return output.isNotEmpty ? output : '';
  }
}
