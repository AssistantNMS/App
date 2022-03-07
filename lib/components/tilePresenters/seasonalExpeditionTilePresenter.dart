import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/components/common/cachedFutureBuilder.dart';
import 'package:flutter/material.dart';
import '../../constants/NmsUIConstants.dart';
import '../../contracts/generated/expeditionViewModel.dart' as expedition_api;
import '../../integration/dependencyInjection.dart';
import '../../pages/seasonalExpedition/seasonalExpeditionPhaseListPage.dart';
import '../../redux/modules/expedition/expeditionViewModel.dart';

import '../../contracts/seasonalExpedition/seasonalExpeditionMilestone.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionPhase.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionSeason.dart';
import '../../helpers/hexHelper.dart';
import '../../pages/seasonalExpedition/seasonalExpeditionDetailPage.dart';
import '../modalBottomSheet/expeditionRewardsListModalBottomSheet.dart';
import '../portal/portalGlyphList.dart';

Widget seasonalExpeditionDetailTilePresenter(
    BuildContext context, SeasonalExpeditionSeason season, useAltGlyphs) {
  return Column(
    children: [
      seasonalExpeditionBase(
        context,
        150,
        season.title,
        season.icon,
        bodyDisplayFunc: () => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Stack(
            children: [
              twoLinePortalGlyphList(
                hexToIntArray(season.portalCode ?? ''),
                useAltGlyphs: useAltGlyphs,
              ),
            ],
          ),
        ),
        bodyFlex: 7,
        imageFlex: 4,
        onTap: () => getNavigation().navigateAsync(
          context,
          navigateTo: (context) => ImageViewerPage(
            season.title,
            season.icon,
            analyticsKey: '',
          ),
        ),
        backgroundColour: getTheme().getScaffoldBackgroundColour(context),
      ),
      if (season.startDate != null && season.endDate != null) ...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(getTranslations().fromKey(LocaleKey.startDate) +
                  ': ' +
                  simpleDate(season.startDate)),
              Text(getTranslations().fromKey(LocaleKey.endDate) +
                  ': ' +
                  simpleDate(season.endDate)),
            ],
          ),
        ),
      ],
    ],
  );
}

Widget seasonalExpeditionPhaseTilePresenter(BuildContext context,
    SeasonalExpeditionPhase seasonalExpedition, ExpeditionViewModel viewModel) {
  int numClaimed = 0;
  for (SeasonalExpeditionMilestone milestone in seasonalExpedition.milestones) {
    if (viewModel.claimedRewards.any((claimed) => claimed == milestone.id)) {
      numClaimed++;
    }
  }

  String description = (seasonalExpedition.milestones.length == numClaimed)
      ? seasonalExpedition.descriptionDone
      : seasonalExpedition.description //
          .replaceAll('0u/', '${numClaimed}u/') //
          .replaceAll('0/', '$numClaimed/');

  return flatCard(
    shadowColor: Colors.transparent,
    child: seasonalExpeditionBase(
      context,
      120,
      seasonalExpedition.title,
      seasonalExpedition.icon,
      bodyDisplayFunc: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          genericItemName(seasonalExpedition.title),
          genericItemDescription(description)
        ],
      ),
      onTap: () {
        getNavigation().navigateAsync(
          context,
          navigateTo: (context) =>
              SeasonalExpeditionDetailPage(seasonalExpedition),
        );
      },
      useMaterial: true,
      backgroundColour: getTheme().getScaffoldBackgroundColour(context),
    ),
  );
}

Widget seasonalExpeditionPhaseMilestoneTilePresenter(
    BuildContext context,
    SeasonalExpeditionMilestone seasonalExpeditionMilestone,
    ExpeditionViewModel viewModel) {
  bool isClaimed = false;
  if (viewModel.claimedRewards
      .any((cla) => cla == seasonalExpeditionMilestone.id)) {
    isClaimed = true;
  }

  String description = isClaimed
      ? seasonalExpeditionMilestone.descriptionDone
      : seasonalExpeditionMilestone.description;

  Container Function(String text, {double fontSize}) textWrapper;
  textWrapper = (String text, {double fontSize}) => Container(
        child: Text(
          text,
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: fontSize == null ? null : TextStyle(fontSize: fontSize),
        ),
        margin: const EdgeInsets.all(4.0),
      );

  return Card(
    child: seasonalExpeditionBase(
      context,
      90,
      seasonalExpeditionMilestone.title,
      seasonalExpeditionMilestone.icon,
      bodyFlex: 8,
      bodyDisplayFunc: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          textWrapper(seasonalExpeditionMilestone.title, fontSize: 20),
          textWrapper(description ?? ''),
        ],
      ),
      trailingFlex: 4,
      trailingDisplayFunc: () => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.info_sharp,
                  size: 30,
                ),
              ),
              adaptiveCheckbox(
                value: isClaimed,
                onChanged: (bool newValue) => newValue
                    ? viewModel.addToClaimedRewards(
                        seasonalExpeditionMilestone.id,
                      )
                    : viewModel.removeFromClaimedRewards(
                        seasonalExpeditionMilestone.id,
                      ),
              ),
            ],
          ),
        ],
      ),
      onTap: () => adaptiveBottomModalSheet(
        context,
        builder: (_) => ExpeditionRewardsListModalBottomSheet(
          seasonalExpeditionMilestone.id,
          seasonalExpeditionMilestone.rewards,
        ),
      ),
    ),
  );
}

Widget seasonalExpeditionBase(
  BuildContext context,
  double height,
  String title,
  String imagePath, {
  bool useMaterial,
  Color backgroundColour,
  int imageFlex = 4,
  int bodyFlex = 9,
  int trailingFlex = 2,
  Widget Function() bodyDisplayFunc,
  Widget Function() trailingDisplayFunc,
  Function() onTap,
}) {
  var child = InkWell(
    borderRadius: BorderRadius.circular(6.0),
    child: Row(children: [
      Expanded(
        flex: imageFlex,
        child: GestureDetector(
          child: localImage(imagePath),
          onTap: () => getNavigation().navigateAsync(
            context,
            navigateTo: (context) => ImageViewerPage(
              title,
              imagePath,
              analyticsKey: '',
            ),
          ),
        ),
      ),
      Expanded(
        flex: bodyFlex,
        child: Container(
          padding: const EdgeInsets.only(top: 5),
          child: bodyDisplayFunc(),
        ),
      ),
      if (trailingDisplayFunc != null) ...[
        Expanded(
          flex: trailingFlex,
          child: Container(
            padding: const EdgeInsets.only(top: 5),
            child: trailingDisplayFunc(),
          ),
        ),
      ]
    ]),
    onTap: onTap,
  );
  return Container(
    height: height,
    padding: const EdgeInsets.all(0),
    color: backgroundColour,
    child: (useMaterial ?? false) ? Material(child: child) : child,
  );
}

Widget expeditionInProgressPresenter(
    BuildContext context, expedition_api.ExpeditionViewModel expedition) {
  Widget bodyChild = Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        genericItemName(expedition.name, maxLines: 2),
        Container(
          child: getProgressbarFromDates(
            context,
            expedition.startDate,
            expedition.endDate,
            animation: true,
          ),
          margin: const EdgeInsets.all(4.0),
        ),
      ],
    ),
  );

  Widget contentChild = Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(children: [
      Expanded(flex: 3, child: networkImage(expedition.imageUrl)),
      Expanded(flex: 7, child: bodyChild),
    ]),
  );

  return Container(
    height: 100,
    padding: const EdgeInsets.all(0),
    child: expedition.link == null
        ? contentChild
        : InkWell(
            borderRadius: BorderRadius.circular(6.0),
            child: contentChild,
            onTap: () => launchExternalURL(expedition.link),
          ),
  );
}

Widget rewardFromSeasonalExpeditionTilePresenter(
    BuildContext context, String seasId) {
  return flatCard(
    shadowColor: Colors.transparent,
    child: CachedFutureBuilder(
      future: getSeasonalExpeditionRepo().getById(context, seasId),
      whileLoading: getLoading().smallLoadingTile(context),
      whenDoneLoading: (ResultWithValue<SeasonalExpeditionSeason> snapshot) {
        SeasonalExpeditionSeason item = snapshot.value;
        return genericListTile(
          context,
          leadingImage: item.icon,
          name: item.title,
          borderRadius: NMSUIConstants.gameItemBorderRadius,
          onTap: () async => await getNavigation().navigateAsync(
            context,
            navigateTo: (_) => SeasonalExpeditionPhaseListPage(seasId),
          ),
        );
      },
    ),
  );
}
