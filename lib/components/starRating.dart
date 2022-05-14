import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

Widget starRating(
  BuildContext context,
  int currentRating, {
  double size = 32,
  Function(int) onTap,
}) {
  onTap ??= (int _) => {};
  Color colour = getTheme().getSecondaryColour(context);
  return Wrap(
    // alignment: WrapAlignment.center,
    children: List.generate(
      5,
      (int index) => (index < currentRating)
          ? GestureDetector(
              child: Icon(Icons.star, color: colour, size: size),
              onTap: () => onTap(index + 1))
          : GestureDetector(
              child: Icon(Icons.star_border, color: colour, size: size),
              onTap: () => onTap(index + 1),
            ),
    ),
  );
}
