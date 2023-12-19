import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/nms_ui_constants.dart';
import '../../contracts/generated/expedition_view_model.dart' as expedition_api;
import '../../contracts/seasonalExpedition/expedition_milestone_type.dart';
import '../../contracts/seasonalExpedition/seasonal_expedition_milestone.dart';
import '../../contracts/seasonalExpedition/seasonal_expedition_phase.dart';
import '../../contracts/seasonalExpedition/seasonal_expedition_season.dart';
import '../../helpers/hex_helper.dart';
import '../../integration/dependency_injection.dart';
import '../../pages/generic/generic_page_descrip_highlight_text.dart';
import '../../pages/seasonalExpedition/seasonal_expedition_detail_page.dart';
import '../../pages/seasonalExpedition/seasonal_expedition_phase_list_page.dart';
import '../../redux/modules/expedition/expedition_view_model.dart';
import '../modalBottomSheet/expedition_rewards_list_modal_bottom_sheet.dart';
import '../portal/portal_glyph_list.dart';

Widget seasonalExpeditionDetailTilePresenter(
  BuildContext context,
  SeasonalExpeditionSeason season,
  bool useAltGlyphs,
) {
  return LayoutBuilder(
    builder: (layoutCtx, BoxConstraints constraints) {
      int numPerLine = 6;
      if (constraints.maxWidth > 1000) {
        numPerLine = 12;
      }
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
                  portalGlyphList(
                    hexToIntArray(season.portalCode ?? ''),
                    numPerLine,
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
      );
    },
  );
}

Widget seasonalExpeditionPhaseTilePresenter(
  BuildContext context,
  SeasonalExpeditionPhase seasonalExpedition,
  ExpeditionViewModel viewModel,
) {
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

  return FlatCard(
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
          GenericItemName(seasonalExpedition.title),
          GenericItemDescription(description),
          const EmptySpace1x(),
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

  String? description = isClaimed
      ? seasonalExpeditionMilestone.descriptionDone
      : seasonalExpeditionMilestone.description;

  textWrapper(String text, {double? fontSize}) => Container(
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

  checkBoxOnTap(bool newValue) => newValue
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
          Container(
            child: textWithHighlightTags(
              context,
              description ?? '',
              List.empty(),
              textAlign: TextAlign.left,
              maxLines: 1,
            ),
            margin: const EdgeInsets.only(left: 4.0),
          ),
          const EmptySpace1x(),
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
              getBaseWidget().adaptiveCheckbox(
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
  bool? useMaterial,
  String? topLeftBanner,
  Color? backgroundColour,
  int imageFlex = 4,
  int bodyFlex = 9,
  int trailingFlex = 2,
  required Widget Function() bodyDisplayFunc,
  Widget Function()? trailingDisplayFunc,
  void Function()? onTap,
}) {
  InkWell innerChild = InkWell(
    borderRadius: BorderRadius.circular(6.0),
    child: Row(children: [
      Expanded(
        flex: imageFlex,
        child: GestureDetector(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: height),
            child: LocalImage(imagePath: imagePath),
          ),
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
    padding: const EdgeInsets.all(0),
    color: backgroundColour,
    child: (useMaterial ?? false) ? Material(child: child) : child,
  );
}

Widget expeditionInProgressPresenter(
  BuildContext context,
  expedition_api.ExpeditionViewModel expedition,
) {
  Widget bodyChild = Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GenericItemName(expedition.name, maxLines: 2),
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
      Expanded(flex: 3, child: ImageFromNetwork(imageUrl: expedition.imageUrl)),
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
            onTap: () => launchExternalURL(expedition.link!),
          ),
  );
}

Widget rewardFromSeasonalExpeditionTilePresenter(
  BuildContext context,
  String seasId,
  bool isCustom,
) {
  return FlatCard(
    shadowColor: Colors.transparent,
    child: CachedFutureBuilder(
      future: getSeasonalExpeditionRepo().getById(context, seasId, isCustom),
      whileLoading: () => getLoading().smallLoadingTile(context),
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
            navigateTo: (_) => SeasonalExpeditionPhaseListPage(
              seasId,
              isCustomExp: isCustom,
            ),
          ),
        );
      },
    ),
  );
}
