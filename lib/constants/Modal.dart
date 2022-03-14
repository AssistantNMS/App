import 'package:flutter/material.dart';

BoxConstraints modalDefaultSize(BuildContext context) {
  return BoxConstraints(
    minHeight: (MediaQuery.of(context).size.height) / 2,
    maxHeight: (MediaQuery.of(context).size.height) * 0.9,
  );
}

BoxConstraints modalFullHeightSize(BuildContext context) {
  return BoxConstraints(
    minHeight: (MediaQuery.of(context).size.height) / 2,
  );
}
