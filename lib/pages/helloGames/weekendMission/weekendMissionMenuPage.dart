import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../components/scaffoldTemplates/genericPageScaffold.dart';
import 'weekendMissionComponents.dart';

class WeekendMissionMenuPage extends StatelessWidget {
  const WeekendMissionMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listItems = [
      weekendMissionSeason2(context),
      weekendMissionSeason1(context),
      weekendMissionWiki(context),
    ];
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.weekendMission),
      body: listWithScrollbar(
        shrinkWrap: true,
        itemCount: listItems.length,
        itemBuilder: (BuildContext context, int index) => listItems[index],
        scrollController: ScrollController(),
      ),
    );
  }
}
