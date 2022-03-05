import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

class SegmentViewItem {
  @required
  LocaleKey title;
  @required
  Widget Function(BuildContext) builder;
  SegmentViewItem({
    this.title,
    this.builder,
  });

  Widget toSegmentOption() => getSegmentedControlOption(
        getTranslations().fromKey(title),
      );
}
