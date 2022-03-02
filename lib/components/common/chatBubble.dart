import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

double defaultElevation = 2;

BubbleStyle weekendMissionBubbleStyle(double elevation) => BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.black12,
      elevation: elevation,
      margin: const BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
BubbleStyle currentUserBubbleStyle(double elevation, Color background) =>
    BubbleStyle(
      nip: BubbleNip.rightBottom,
      color: background,
      elevation: elevation,
      margin: const BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );
BubbleStyle currentUserBubbleOptionStyle(double elevation, Color background) =>
    BubbleStyle(
      nip: BubbleNip.no,
      color: background,
      elevation: elevation,
      margin: const BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.bottomRight,
    );

Widget weekendMissionBubble(String message) {
  return Bubble(
    style: weekendMissionBubbleStyle(defaultElevation),
    child: Text(message, style: const TextStyle(color: Colors.white)),
  );
}

Widget currentUserBubbleOption(BuildContext context, String message) {
  return Padding(
    padding: const EdgeInsets.all(4),
    child: Container(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: getTheme().getSecondaryColour(context),
      ),
    ),
  );
}

Widget currentUserBubble(BuildContext context, String message) {
  return Bubble(
    style: currentUserBubbleStyle(
      defaultElevation,
      getTheme().getPrimaryColour(context),
    ),
    child: Text(message, style: const TextStyle(color: Colors.white)),
  );
}

Widget userLeftBubble(BuildContext context, String message) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        message,
        style: TextStyle(
          color: getTheme().getTextColour(context),
          fontStyle: FontStyle.italic,
        ),
      ),
    ],
  );
}
