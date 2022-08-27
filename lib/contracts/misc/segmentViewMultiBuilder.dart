import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

class SegmentViewMultiBuilder {
  @required
  LocaleKey title;
  @required
  List<List<Widget> Function(BuildContext)> builders;
  SegmentViewMultiBuilder({
    this.title,
    this.builders,
  });

  Widget toSegmentOption() => getSegmentedControlOption(
        getTranslations().fromKey(title),
      );
}
