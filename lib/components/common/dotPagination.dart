import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import './prevAndNextPagination.dart';

Widget dotPagination(
  BuildContext context, {
  @required Widget content,
  @required int numberOfDots,
  @required int currentPosition,
  @required LocaleKey prevLocaleKey,
  @required LocaleKey nextLocaleKey,
  void Function() onPreviousTap,
  void Function() onNextTap,
  void Function(int) onDotTap,
}) {
  return prevAndNextPagination(
    context,
    content: content,
    currentPosition: currentPosition,
    maxPositionIndex: numberOfDots,
    prevLocaleKey: prevLocaleKey,
    nextLocaleKey: nextLocaleKey,
    additionalWidget: Row(children: [
      Expanded(
        child: Center(
          child: DotsIndicator(
            dotsCount: numberOfDots,
            position: currentPosition.toDouble(),
            decorator: DotsDecorator(
              activeColor: getTheme().getSecondaryColour(context),
            ),
            onTap: (double dotIndex) => onDotTap(dotIndex.toInt()),
          ),
        ),
      )
    ]),
    onPreviousTap: () {
      if (onPreviousTap != null) {
        onPreviousTap();
        return;
      }
      if (onDotTap != null) {
        onDotTap(currentPosition - 1);
        return;
      }
    },
    onNextTap: () {
      if (onNextTap != null) {
        onNextTap();
        return;
      }
      if (onDotTap != null) {
        onDotTap(currentPosition + 1);
        return;
      }
    },
  );
}
