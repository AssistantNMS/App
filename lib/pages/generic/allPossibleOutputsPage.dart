import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../constants/AnalyticsEvent.dart';

class AllPossibleOutputsPage<T> extends StatelessWidget {
  final List<T> requiredItems;
  final String title;
  final Widget Function(BuildContext context, T p) presenter;

  AllPossibleOutputsPage(this.requiredItems, this.title, this.presenter) {
    getAnalytics().trackEvent(AnalyticsEvent.allPossibleOutputsPage);
  }

  @override
  Widget build(BuildContext context) {
    return genericPageScaffold(
      context, this.title, null, //unused
      body: getBody,
    );
  }

  Widget getBody(BuildContext context, unused) {
    List<Widget> widgets = List.empty(growable: true);
    if (this.requiredItems.length > 0) {
      widgets.addAll(
          this.requiredItems.map((p) => presenter(context, p)).toList());
    } else {
      widgets.add(
        Container(
          child: Text(
            getTranslations().fromKey(LocaleKey.noItems),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20),
          ),
          margin: EdgeInsets.only(top: 30),
        ),
      );
    }

    widgets.add(emptySpace8x());

    return Column(
      children: [
        Expanded(
          child: listWithScrollbar(
            itemCount: widgets.length,
            itemBuilder: (context, index) => widgets[index],
          ),
        ),
      ],
    );
  }
}
