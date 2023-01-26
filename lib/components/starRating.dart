import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

Widget starRating(
  BuildContext context,
  int currentRating, {
  double size = 32,
  void Function(int)? onTap,
}) {
  void Function(int) localOnTap = onTap ?? (int _) => {};
  Color colour = getTheme().getSecondaryColour(context);
  return Wrap(
    // alignment: WrapAlignment.center,
    children: List.generate(
      5,
      (int index) => (index < currentRating)
          ? GestureDetector(
              child: Icon(Icons.star, color: colour, size: size),
              onTap: () => localOnTap(index + 1))
          : GestureDetector(
              child: Icon(Icons.star_border, color: colour, size: size),
              onTap: () => localOnTap(index + 1),
            ),
    ),
  );
}
