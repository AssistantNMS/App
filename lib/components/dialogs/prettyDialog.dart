import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

// import 'package:giffy_dialog/giffy_dialog.dart';

void prettyDialog(
  BuildContext context,
  String appImage,
  String title,
  String description, {
  bool onlyCancelButton = false,
  void Function(BuildContext) onCancel,
  void Function(BuildContext) onSuccess,
}) {
  getDialog().showSimpleDialog(
    context,
    '',
    Column(
      children: [
        localImage(appImage),
        if (title != null) ...[
          emptySpace1x(),
          genericItemText(title),
          emptySpace1x(),
        ],
        genericItemDescription(description),
      ],
    ),
    /*
      buttonOkText: Text(getTranslations().fromKey(LocaleKey.noticeAccept)),
      buttonOkColor: getTheme().getSecondaryColour(context),
      onOkButtonPressed: () {
        if (onSuccess != null) onSuccess(context);
        getNavigation().pop(dialogCtx);
      },
      onlyCancelButton: onlyCancelButton,
      buttonCancelText: Text(onlyCancelButton
          ? getTranslations().fromKey(LocaleKey.noticeAccept)
          : getTranslations().fromKey(LocaleKey.close)),
      onCancelButtonPressed: onCancel == null ? null : () => onCancel(context),
      */
    // ),
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
  void Function(BuildContext) onCancel,
  void Function(BuildContext) onSuccess,
}) async {
  var localCancelButtonText = cancelButtonText;
  localCancelButtonText ??= onlyCancelButton
      ? getTranslations().fromKey(LocaleKey.noticeAccept)
      : getTranslations().fromKey(LocaleKey.close);

  getDialog().showSimpleDialog(
    context,
    '',
    Column(
      children: [
        localImage(appImage, boxfit: BoxFit.fitWidth, width: 200),
        if (title != null) ...[
          emptySpace1x(),
          genericItemText(title),
          emptySpace1x(),
        ],
        genericItemDescription(description),
      ],
    ),
  );
}
