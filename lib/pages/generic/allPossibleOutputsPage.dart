import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../constants/AnalyticsEvent.dart';

class AllPossibleOutputsPage<T> extends StatelessWidget {
  final List<T> requiredItems;
  final String title;
  final Widget Function(BuildContext context, T p) presenter;

  AllPossibleOutputsPage(this.requiredItems, this.title, this.presenter,
      {Key? key})
      : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.allPossibleOutputsPage);
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: title,
      body: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    List<Widget> widgets = List.empty(growable: true);
    if (requiredItems.isNotEmpty) {
      widgets.addAll(requiredItems.map((p) => presenter(context, p)).toList());
    } else {
      widgets.add(
        Container(
          child: Text(
            getTranslations().fromKey(LocaleKey.noItems),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20),
          ),
          margin: const EdgeInsets.only(top: 30),
        ),
      );
    }

    widgets.add(emptySpace8x());

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }
}
