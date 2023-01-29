import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/faction_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/faction/guild_mission.dart';
import '../../integration/dependencyInjection.dart';

class GuildMissionsPage extends StatelessWidget {
  GuildMissionsPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.guildMissionsPage);
  }

  @override
  Widget build(BuildContext context) {
    return CachedFutureBuilder(
      future: getFactionRepo().getAllMissions(context),
      whileLoading: () => simpleGenericPageScaffold(
        context,
        title: getTranslations().fromKey(LocaleKey.loading),
        body: getLoading().fullPageLoading(context),
      ),
      whenDoneLoading: (ResultWithValue<List<GuildMission>> snapshot) =>
          getBody(context, snapshot),
    );
  }

  Widget getBody(
    BuildContext bodyCtx,
    ResultWithValue<List<GuildMission>> snapshot,
  ) {
    if (snapshot.isSuccess == false) {
      return simpleGenericPageScaffold(
        bodyCtx,
        title: getTranslations().fromKey(LocaleKey.error),
        body: getLoading().customErrorWidget(bodyCtx),
      );
    }
    List<Widget Function(BuildContext t)> widgets = List.empty(growable: true);
    List<GuildMission> missions = snapshot.value;
    for (GuildMission mission in missions) {
      widgets.add((innerCtx) => guildMissionTilePresenter(bodyCtx, mission));
    }

    widgets.add((_) => const EmptySpace8x());

    return simpleGenericPageScaffold(
      bodyCtx,
      title: getTranslations().fromKey(LocaleKey.viewGuildMissions),
      body: listWithScrollbar(
        itemCount: widgets.length,
        itemBuilder: (listCtx, index) => widgets[index](listCtx),
        scrollController: ScrollController(),
      ),
    );
  }
}
