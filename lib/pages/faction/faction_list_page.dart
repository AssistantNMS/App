import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/faction_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/faction/faction.dart';
import '../../integration/dependency_injection.dart';

class FactionPage extends StatelessWidget {
  FactionPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.factionPage);
  }

  @override
  Widget build(BuildContext context) {
    return CachedFutureBuilder(
      future: getFactionRepo().getAll(context),
      whileLoading: () => simpleGenericPageScaffold(
        context,
        title: getTranslations().fromKey(LocaleKey.loading),
        body: getLoading().fullPageLoading(context),
      ),
      whenDoneLoading: (ResultWithValue<FactionData> snapshot) =>
          getBody(context, snapshot),
    );
  }

  Widget getBody(
    BuildContext bodyCtx,
    ResultWithValue<FactionData> snapshot,
  ) {
    if (snapshot.isSuccess == false) {
      return simpleGenericPageScaffold(
        bodyCtx,
        title: getTranslations().fromKey(LocaleKey.error),
        body: getLoading().customErrorWidget(bodyCtx),
      );
    }
    FactionData faction = snapshot.value;

    List<Widget> widgets = List.empty(growable: true);
    widgets.add(categoryHeading(faction.category));
    for (FactionDetail detail in faction.categories) {
      widgets.add(factionTilePresenter(bodyCtx, detail));
    }
    widgets.add(categoryHeading(faction.lifeform));
    for (FactionDetail detail in faction.lifeforms) {
      widgets.add(factionTilePresenter(bodyCtx, detail));
    }
    widgets.add(categoryHeading(faction.guild));
    for (FactionDetail detail in faction.guilds) {
      widgets.add(factionTilePresenter(bodyCtx, detail));
    }

    widgets.add(const EmptySpace8x());

    return simpleGenericPageScaffold(
      bodyCtx,
      title: getTranslations().fromKey(LocaleKey.milestones),
      body: listWithScrollbar(
        itemCount: widgets.length,
        itemBuilder: (context, index) => widgets[index],
        scrollController: ScrollController(),
      ),
    );
  }

  Widget categoryHeading(String title) {
    return FlatCard(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: GenericItemName(title),
      ),
    );
  }
}
