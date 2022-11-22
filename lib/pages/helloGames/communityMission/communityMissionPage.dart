import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/AppImage.dart';
import 'package:assistantnms_app/constants/NmsExternalUrls.dart';
import 'package:flutter/material.dart';

import '../../../components/common/cachedFutureBuilder.dart';
import '../../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../../constants/AnalyticsEvent.dart';
import '../../../contracts/data/quicksilverStore.dart';
import '../../../contracts/helloGames/communityMission.dart';
import '../../../contracts/helloGames/communityMissionPageData.dart';
import '../../../contracts/helloGames/quickSilverStoreDetails.dart';
import '../../../contracts/requiredItemDetails.dart';
import '../../../helpers/futureHelper.dart';
import '../../../helpers/mathHelper.dart';
import '../../../integration/dependencyInjection.dart';
import 'communityMissionRewardDetails.dart';
import 'communityMissionRewards.dart';

class CommunityMissionPage extends StatelessWidget {
  CommunityMissionPage({Key key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.communityMissionPage);
  }

  Future<ResultWithValue<CommunityMissionPageData>>
      getLocalCommunityMissionDataAndResultFromApi(BuildContext context) async {
    Future<ResultWithValue<List<QuicksilverStore>>> allQsItemsTask =
        getDataRepo().getQuickSilverItems(context);

    ResultWithValue<CommunityMission> apiResult =
        await getHelloGamesApiService().getCommunityMission();
    if (apiResult.isSuccess == false) {
      return ResultWithValue<CommunityMissionPageData>(false, null, '');
    }

    int missionId = apiResult.value.missionId;
    ResultWithValue<QuicksilverStoreDetails> qsDataResult =
        await quickSilverItemDetailsFuture(context, missionId);
    if (qsDataResult.isSuccess == false) {
      return ResultWithValue<CommunityMissionPageData>(false, null, '');
    }

    ResultWithValue<List<QuicksilverStore>> qsItemResult = await allQsItemsTask;
    if (qsItemResult.isSuccess == false) {
      return ResultWithValue<CommunityMissionPageData>(false, null, '');
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
        whileLoading: getLoading().fullPageLoading(
          context,
          loadingText: getTranslations().fromKey(LocaleKey.loading),
        ),
      ),
    );
  }

  Widget getBody(BuildContext bodyCtx,
      ResultWithValue<CommunityMissionPageData> snapshot) {
    if (snapshot.value == null ||
        snapshot.value.apiData.currentTier == null ||
        snapshot.value.apiData.totalTiers == null ||
        snapshot.value.apiData.percentage == null ||
        snapshot.value.apiData.missionId == null) {
      return getLoading().customErrorWidget(bodyCtx);
    }

    List<Widget> widgets = List.empty(growable: true);

    int missionId = snapshot.value.apiData.missionId;
    int percentage = snapshot.value.apiData.percentage;
    int totalTiers = snapshot.value.apiData.totalTiers;
    int currentTier = snapshot.value.apiData.currentTier;
    QuicksilverStore qsStore = snapshot.value.qsStore;
    List<RequiredItemDetails> itemDetails = snapshot.value.itemDetails;
    List<RequiredItemDetails> reqItemDetails =
        snapshot.value.requiredItemDetails;

    int communityMissionMax = snapshot.value.communityMissionMax;
    int communityMissionMin = snapshot.value.communityMissionMin;

    widgets.add(emptySpace2x());
    widgets.add(genericItemGroup(
      getTranslations().fromKey(LocaleKey.researchProgress),
    ));

    if (totalTiers > 1) {
      widgets.add(genericItemDescription("$currentTier / $totalTiers"));
    }

    widgets.add(Padding(
      padding: const EdgeInsets.all(15.0),
      child: horizontalProgressBar(
        bodyCtx,
        percentage.toDouble(),
        text: Text(
          '${percentage.toStringAsFixed(0)}%',
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ));

    widgets.add(
      genericItemDescription(
          getTranslations().fromKey(LocaleKey.communityMissionContent)),
    );

    widgets.add(emptySpace2x());
    widgets.add(flatCard(
      child: genericListTileWithSubtitle(
        bodyCtx,
        leadingImage: AppImage.communityMissionProgress,
        name: 'Community Mission Progress Tracker',
        subtitle: const Text('View progress over time'),
        trailing: const Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.open_in_new_rounded),
        ),
        onTap: () =>
            launchExternalURL(NmsExternalUrls.communityMissionProgress),
      ),
    ));
    widgets.add(emptySpace1x());

    widgets.add(customDivider());
    widgets.add(CommunityMissionRewards(
      missionId,
      currentTier: currentTier,
      currentTierPercentage: percentage,
      totalTiers: totalTiers,
      qsStore: qsStore,
      itemDetails: itemDetails,
      requiredItemDetails: reqItemDetails,
    ));

    Widget viewCommunityMissionsButton(
        LocaleKey buttonLocale, int missionIdToView) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: positiveButton(
            bodyCtx,
            title: getTranslations().fromKey(buttonLocale),
            padding: const EdgeInsets.symmetric(vertical: 8),
            onPress: () async =>
                await getNavigation().navigateAwayFromHomeAsync(
              bodyCtx,
              navigateTo: (context) => CommunityMissionRewardDetailsPage(
                missionIdToView,
                communityMissionMin,
                communityMissionMax,
              ),
            ),
          ),
        ),
        flex: 1,
      );
    }

    widgets.add(emptySpace8x());

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

    widgets.add(emptySpace8x());

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
