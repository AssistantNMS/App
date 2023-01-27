import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import 'rowHelper.dart';

Widget prevAndNextPagination(
  BuildContext context, {
  required Widget content,
  required int currentPosition,
  required int maxPositionIndex,
  required LocaleKey prevLocaleKey,
  required LocaleKey nextLocaleKey,
  Widget? additionalWidget,
  void Function()? onPreviousTap,
  void Function()? onNextTap,
}) {
  Widget buttonWidget = Container();

  Widget prevButton = PositiveButton(
    title: getTranslations().fromKey(prevLocaleKey),
    padding: const EdgeInsets.symmetric(vertical: 8),
    onTap: () {
      if (onPreviousTap != null) {
        onPreviousTap();
        return;
      }
    },
  );

  Widget nextButton = PositiveButton(
    title: getTranslations().fromKey(nextLocaleKey),
    padding: const EdgeInsets.symmetric(vertical: 8),
    onTap: () {
      if (onNextTap != null) {
        onNextTap();
        return;
      }
    },
  );

  bool showBothButtons = true;
  if (currentPosition >= maxPositionIndex - 1) {
    showBothButtons = false;
    buttonWidget = prevButton;
  }
  if (currentPosition <= 0) {
    showBothButtons = false;
    buttonWidget = nextButton;
  }

  if (showBothButtons) {
    buttonWidget = rowWith2Columns(prevButton, nextButton);
  }
  return Stack(
    fit: StackFit.expand,
    children: [
      content,
      Positioned(
        left: 0,
        right: 0,
        bottom: 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: getTheme().getScaffoldBackgroundColour(context),
          ),
          child: Column(
            children: [
              if (additionalWidget != null) ...[additionalWidget],
              buttonWidget,
            ],
          ),
        ),
      ),
    ],
  );
}
