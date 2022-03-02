import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

void prettyDialog(
  BuildContext context,
  String appImage,
  String title,
  String description, {
  bool onlyCancelButton = false,
  Function() onCancel,
  Function() onSuccess,
}) {
  showDialog(
    context: context,
    builder: (_) => NetworkGiffyDialog(
      image: localImage(appImage),
      title: title != null
          ? Text(
              title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
            )
          : null,
      description: Text(description, textAlign: TextAlign.center),
      entryAnimation: EntryAnimation.TOP,
      buttonOkText: Text(getTranslations().fromKey(LocaleKey.noticeAccept)),
      buttonOkColor: getTheme().getSecondaryColour(context),
      onOkButtonPressed: () {
        if (onSuccess != null) onSuccess();
        Navigator.pop(context);
      },
      onlyCancelButton: onlyCancelButton,
      buttonCancelText: Text(onlyCancelButton
          ? getTranslations().fromKey(LocaleKey.noticeAccept)
          : getTranslations().fromKey(LocaleKey.close)),
      onCancelButtonPressed: onCancel,
    ),
  );
}

void prettyDialogAsync(
  BuildContext context,
  String appImage,
  String title,
  String description, {
  bool onlyCancelButton = false,
  String okButtonText,
  Color buttonOkColor,
  String cancelButtonText,
  Function() onCancel,
  Function() onSuccess,
}) async {
  var localCancelButtonText = cancelButtonText;
  localCancelButtonText ??= onlyCancelButton
      ? getTranslations().fromKey(LocaleKey.noticeAccept)
      : getTranslations().fromKey(LocaleKey.close);

  bool result = await showDialog<bool>(
    context: context,
    builder: (_) => NetworkGiffyDialog(
      image: localImage(appImage),
      title: title != null
          ? Text(
              title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
            )
          : null,
      description: Text(description, textAlign: TextAlign.center),
      entryAnimation: EntryAnimation.TOP,
      buttonOkText: Text(
        okButtonText ?? getTranslations().fromKey(LocaleKey.noticeAccept),
      ),
      buttonOkColor: buttonOkColor ?? getTheme().getSecondaryColour(context),
      onOkButtonPressed: () {
        Navigator.pop(context, true);
      },
      onlyCancelButton: onlyCancelButton,
      buttonCancelText: Text(localCancelButtonText),
      onCancelButtonPressed: () {
        Navigator.pop(context, false);
      },
    ),
  );
  if (result == null || result == false) {
    if (onCancel != null) onCancel();
  } else {
    if (onSuccess != null) onSuccess();
  }
}
