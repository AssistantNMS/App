import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/common/cachedFutureBuilder.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/factionTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/faction/faction.dart';
import '../../integration/dependencyInjection.dart';

class FactionPage extends StatelessWidget {
  FactionPage({Key key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.factionPage);
  }

  @override
  Widget build(BuildContext context) {
    return CachedFutureBuilder(
      future: getFactionRepo().getAll(context),
      whileLoading: getLoading().fullPageLoading(context),
      whenDoneLoading: (ResultWithValue<FactionData> snapshot) =>
          getBody(context, snapshot),
    );
    //factionTilePresenter
  }

  Widget getBody(BuildContext bodyCtx, ResultWithValue<FactionData> snapshot) {
    if (snapshot == null || snapshot.isSuccess == false) {
      return simpleGenericPageScaffold(
        bodyCtx,
        title: getTranslations().fromKey(LocaleKey.loading),
        body: getLoading().customErrorWidget(bodyCtx),
      );
    }
    FactionData faction = snapshot.value;

    List<Widget> widgets = List.empty(growable: true);
    // widgets.add(flatCard(child: genericItemName(faction.category)));
    for (FactionDetail detail in faction.categories) {
      widgets.add(factionTilePresenter(bodyCtx, detail));
    }
    widgets.add(flatCard(child: genericItemName(faction.lifeform)));
    for (FactionDetail detail in faction.lifeforms) {
      widgets.add(factionTilePresenter(bodyCtx, detail));
    }
    widgets.add(flatCard(child: genericItemName(faction.guild)));
    for (FactionDetail detail in faction.guilds) {
      widgets.add(factionTilePresenter(bodyCtx, detail));
    }

    widgets.add(emptySpace8x());

    return simpleGenericPageScaffold(
      bodyCtx,
      title: faction.milestone,
      body: listWithScrollbar(
        itemCount: widgets.length,
        itemBuilder: (context, index) => widgets[index],
      ),
    );
  }
}
