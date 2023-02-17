import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

class SegmentViewItem {
  LocaleKey title;
  Widget Function(BuildContext) builder;

  SegmentViewItem({
    required this.title,
    required this.builder,
  });

  Widget toSegmentOption() => SegmentedControlOption(
        getTranslations().fromKey(title),
      );
}
