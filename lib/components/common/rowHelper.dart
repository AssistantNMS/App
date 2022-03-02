import 'package:flutter/material.dart';

Widget rowWith2Columns(Widget column1, Widget column2) {
  return Row(children: [
    Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 4, bottom: 4),
        child: column1,
      ),
      flex: 1,
    ),
    Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 8, bottom: 4),
        child: column2,
      ),
      flex: 1,
    ),
  ]);
}
