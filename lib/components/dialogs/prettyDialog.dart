import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

void prettyDialog(
  BuildContext dialogCtx,
  String appImage,
  String title,
  String description, {
  bool onlyCancelButton = false,
  String? okButtonText,
  Color? buttonOkColor,
  String? cancelButtonText,
  void Function(BuildContext)? onCancel,
  void Function(BuildContext)? onSuccess,
}) {
  var localCancelButtonText = cancelButtonText;
  localCancelButtonText ??= onlyCancelButton
      ? getTranslations().fromKey(LocaleKey.noticeAccept)
      : getTranslations().fromKey(LocaleKey.close);

  List<Widget> buttons = List.empty(growable: true);
  if (onlyCancelButton == false) {
    buttons.add(
      PositiveButton(
        title: getTranslations().fromKey(LocaleKey.noticeAccept),
        onTap: () {
          if (onSuccess != null) onSuccess(dialogCtx);
          getNavigation().pop(dialogCtx);
        },
      ),
    );
  }

  buttons.add(
    PositiveButton(
      title: localCancelButtonText,
      onTap: onCancel == null ? null : () => onCancel(dialogCtx),
    ),
  );

  getDialog().showSimpleDialog(
    dialogCtx,
    '',
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        localImage(appImage),
        emptySpace1x(),
        genericItemText(title),
        emptySpace1x(),
        genericItemDescription(description),
      ],
    ),
  );
}
