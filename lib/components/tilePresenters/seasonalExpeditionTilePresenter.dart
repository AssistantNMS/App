import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/components/common/cachedFutureBuilder.dart';
import 'package:flutter/material.dart';
import '../../constants/NmsUIConstants.dart';
import '../../contracts/generated/expeditionViewModel.dart' as expedition_api;
import '../../contracts/seasonalExpedition/expeditionMilestoneType.dart';
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
          genericItemDescription(description),
          emptySpace1x(),
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

  bool hasRewards = seasonalExpeditionMilestone.rewards.isNotEmpty;

  void Function(bool) checkBoxOnTap;
  checkBoxOnTap = (bool newValue) => newValue
      ? viewModel.addToClaimedRewards(
          seasonalExpeditionMilestone.id,
        )
      : viewModel.removeFromClaimedRewards(
          seasonalExpeditionMilestone.id,
        );

  void Function() rewardOnTap = () => checkBoxOnTap(!isClaimed);
  if (hasRewards) {
    rewardOnTap = () => adaptiveBottomModalSheet(
          context,
          hasRoundedCorners: true,
          builder: (_) => ExpeditionRewardsListModalBottomSheet(
            seasonalExpeditionMilestone.id,
            seasonalExpeditionMilestone.rewards,
          ),
        );
  }

  return Card(
    child: seasonalExpeditionBase(
      context,
      90,
      seasonalExpeditionMilestone.title,
      seasonalExpeditionMilestone.icon,
      topLeftBanner: seasonalExpeditionMilestone.type ==
              SeasonalExpeditionMilestoneType.Optional
          ? 'Optional'
          : null,
      bodyFlex: 8,
      bodyDisplayFunc: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          textWrapper(seasonalExpeditionMilestone.title, fontSize: 20),
          textWrapper(description ?? ''),
          emptySpace1x(),
        ],
      ),
      trailingFlex: hasRewards ? 4 : 2,
      trailingDisplayFunc: () => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              if (hasRewards) ...[
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.info_sharp,
                    size: 30,
                  ),
                ),
              ],
              adaptiveCheckbox(
                value: isClaimed,
                onChanged: checkBoxOnTap,
              ),
            ],
          ),
        ],
      ),
      onTap: rewardOnTap,
    ),
  );
}

Widget seasonalExpeditionBase(
  BuildContext context,
  double height,
  String title,
  String imagePath, {
  bool useMaterial,
  String topLeftBanner,
  Color backgroundColour,
  int imageFlex = 4,
  int bodyFlex = 9,
  int trailingFlex = 2,
  Widget Function() bodyDisplayFunc,
  Widget Function() trailingDisplayFunc,
  Function() onTap,
}) {
  InkWell innerChild = InkWell(
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
  Widget child = innerChild;
  if (topLeftBanner != null) {
    child = ClipRect(
      child: Banner(
        message: 'Optional', // TODO translate
        location: BannerLocation.topEnd,
        child: innerChild,
      ),
    );
  }
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
      crossAxisAlignment: CrossAxisAlignment.center,
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
        return genericListTileWithSubtitle(
          context,
          leadingImage: item.icon,
          name: item.title,
          subtitle: Text(
              getTranslations().fromKey(LocaleKey.seasonalExpeditionSeasons)),
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
