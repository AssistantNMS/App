import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../../constants/analytics_event.dart';
import '../../../contracts/data/quicksilver_store.dart';
import '../../../contracts/enum/community_mission_status.dart';
import '../../../contracts/helloGames/community_mission.dart';
import '../../../contracts/helloGames/community_mission_page_data.dart';
import '../../../contracts/helloGames/quick_silver_store_details.dart';
import '../../../contracts/required_item_details.dart';
import '../../../helpers/future_helper.dart';
import '../../../helpers/math_helper.dart';
import '../../../integration/dependency_injection.dart';
import 'community_mission_reward_details.dart';
import 'community_mission_rewards.dart';

class CommunityMissionPage extends StatelessWidget {
  CommunityMissionPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.communityMissionPage);
  }

  Future<ResultWithValue<CommunityMissionPageData>>
      getLocalCommunityMissionDataAndResultFromApi(BuildContext context) async {
    Future<ResultWithValue<List<QuicksilverStore>>> allQsItemsTask =
        getDataRepo().getQuickSilverItems(context);

    ResultWithValue<CommunityMission> apiResult =
        await getHelloGamesApiService().getCommunityMission();
    if (apiResult.isSuccess == false) {
      return ResultWithValue<CommunityMissionPageData>(
        false,
        CommunityMissionPageData.initial(),
        '',
      );
    }

    int missionId = apiResult.value.missionId;
    ResultWithValue<QuicksilverStoreDetails> qsDataResult =
        await quickSilverItemDetailsFuture(context, missionId);
    if (qsDataResult.isSuccess == false) {
      return ResultWithValue<CommunityMissionPageData>(
        false,
        CommunityMissionPageData.initial(),
        '',
      );
    }

    ResultWithValue<List<QuicksilverStore>> qsItemResult = await allQsItemsTask;
    if (qsItemResult.isSuccess == false) {
      return ResultWithValue<CommunityMissionPageData>(
        false,
        CommunityMissionPageData.initial(),
        '',
      );
    }

    int communityMissionMax = maxFromArr<QuicksilverStore>(
        qsItemResult.value, (qList) => qList.missionId);
    int communityMissionMin = minFromArr<QuicksilverStore>(
        qsItemResult.value, (qList) => qList.missionId);
    CommunityMissionPageData data = CommunityMissionPageData(
      apiData: apiResult.value,
      itemDetails: qsDataResult.value.items,
      qsStore: qsDataResult.value.store,
      communityMissionMax: communityMissionMax,
      communityMissionMin: communityMissionMin,
      requiredItemDetails: qsDataResult.value.itemsRequired,
    );
    return ResultWithValue<CommunityMissionPageData>(true, data, '');
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.communityMission),
      body: CachedFutureBuilder(
        future: getLocalCommunityMissionDataAndResultFromApi(context),
        whenDoneLoading: (ResultWithValue<CommunityMissionPageData> snapshot) =>
            getBody(context, snapshot),
        whileLoading: () => getLoading().fullPageLoading(
          context,
          loadingText: getTranslations().fromKey(LocaleKey.loading),
        ),
      ),
    );
  }

  Widget getBody(
    BuildContext bodyCtx,
    ResultWithValue<CommunityMissionPageData> result,
  ) {
    List<Widget> widgets = List.empty(growable: true);

    int missionId = result.value.apiData.missionId;
    int percentage = result.value.apiData.percentage;
    int totalTiers = result.value.apiData.totalTiers;
    int currentTier = result.value.apiData.currentTier;
    QuicksilverStore qsStore = result.value.qsStore;
    List<RequiredItemDetails> itemDetails = result.value.itemDetails;
    List<RequiredItemDetails> reqItemDetails = result.value.requiredItemDetails;

    int communityMissionMax = result.value.communityMissionMax;
    int communityMissionMin = result.value.communityMissionMin;

    widgets.add(const EmptySpace2x());
    widgets.add(GenericItemGroup(
      getTranslations().fromKey(LocaleKey.researchProgress),
    ));

    if (totalTiers > 1) {
      widgets.add(GenericItemDescription("$currentTier / $totalTiers"));
    }

    widgets.add(Padding(
      padding: const EdgeInsets.all(15.0),
      child: HorizontalProgressBar(
        percent: percentage.toDouble(),
        text: Text(
          '${percentage.toStringAsFixed(0)}%',
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ));

    widgets.add(
      GenericItemDescription(
          getTranslations().fromKey(LocaleKey.communityMissionContent)),
    );

    widgets.add(const EmptySpace1x());
    widgets.add(customDivider());
    widgets.add(CommunityMissionRewards(
      missionId,
      CommunityMissionStatus.current,
      currentTier: currentTier,
      currentTierPercentage: percentage,
      totalTiers: totalTiers,
      qsStore: qsStore,
      itemDetails: itemDetails,
      requiredItemDetails: reqItemDetails,
    ));

    Widget viewCommunityMissionsButton(
      LocaleKey buttonLocale,
      int missionIdToView,
    ) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: PositiveButton(
            title: getTranslations().fromKey(buttonLocale),
            padding: const EdgeInsets.symmetric(vertical: 8),
            onTap: () async => await getNavigation().navigateAwayFromHomeAsync(
              bodyCtx,
              navigateTo: (context) => CommunityMissionRewardDetailsPage(
                missionIdToView,
                missionId,
                communityMissionMin,
                communityMissionMax,
              ),
            ),
          ),
        ),
        flex: 1,
      );
    }

    widgets.add(const EmptySpace8x());

    List<Widget> rowWidgets = List.empty(growable: true);
    rowWidgets.add(viewCommunityMissionsButton(
      LocaleKey.prevCommunityMission,
      (missionId - 1),
    ));
    if (missionId < communityMissionMax) {
      rowWidgets.add(viewCommunityMissionsButton(
        LocaleKey.nextCommunityMission,
        (missionId + 1),
      ));
    }
    // widgets.add(Row(children: rowWidgets));

    widgets.add(const EmptySpace8x());

    return Stack(
      children: [
        listWithScrollbar(
          itemCount: widgets.length,
          itemBuilder: (context, index) => widgets[index],
          scrollController: ScrollController(),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 2,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Row(children: rowWidgets),
            ),
            color: getTheme().getScaffoldBackgroundColour(bodyCtx),
          ),
        ),
      ],
    );
  }
}
