import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

class SegmentViewMultiBuilder {
  int enumIndex;
  LocaleKey title;
  List<List<Widget> Function(BuildContext)> builders;

  SegmentViewMultiBuilder({
    required this.enumIndex,
    required this.title,
    required this.builders,
  });

  Widget toSegmentOption() => SegmentedControlOption(
        getTranslations().fromKey(title),
      );
}
