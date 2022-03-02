import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import 'rowHelper.dart';

Widget prevAndNextPagination(
  BuildContext context, {
  @required Widget content,
  @required int currentPosition,
  @required int maxPositionIndex,
  @required LocaleKey prevLocaleKey,
  @required LocaleKey nextLocaleKey,
  Widget additionalWidget,
  void Function() onPreviousTap,
  void Function() onNextTap,
}) {
  Widget buttonWidget = Container();

  var prevButton = positiveButton(
      title: getTranslations().fromKey(prevLocaleKey),
      colour: getTheme().getSecondaryColour(context),
      padding: const EdgeInsets.symmetric(vertical: 8),
      onPress: () {
        if (onPreviousTap != null) {
          onPreviousTap();
          return;
        }
      });

  var nextButton = positiveButton(
      title: getTranslations().fromKey(nextLocaleKey),
      colour: getTheme().getSecondaryColour(context),
      padding: const EdgeInsets.symmetric(vertical: 8),
      onPress: () {
        if (onNextTap != null) {
          onNextTap();
          return;
        }
      });

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
        bottom: 0,
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
