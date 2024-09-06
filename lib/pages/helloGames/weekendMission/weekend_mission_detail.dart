// ignore_for_file: no_logic_in_create_state

import 'package:after_layout/after_layout.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../components/common/dot_pagination.dart';
import '../../../components/common/image.dart';
import '../../../components/portal/portal_glyph_list.dart';
import '../../../components/tilePresenters/required_item_details_tile_presenter.dart';
import '../../../components/tilePresenters/youtubers_tile_presenter.dart';
import '../../../contracts/generated/weekend_mission_view_model.dart';
import '../../../contracts/redux/app_state.dart';
import '../../../contracts/required_item_details.dart';
import '../../../contracts/weekend_mission.dart';
import '../../../contracts/weekend_stage_page_item.dart';
import '../../../helpers/hex_helper.dart';
import '../../../integration/dependency_injection.dart';
import '../../../redux/modules/portal/portal_glyph_view_model.dart';
import 'weekend_mission_dialog.dart';

class WeekendMissionDetail extends StatefulWidget {
  final int weekendMissionLevelMin;
  final int weekendMissionLevelMax;
  final WeekendStagePageItem pageItem;
  final Future<ResultWithValue<WeekendStagePageItem>> Function(
          BuildContext context, String seasonId, int level)
      getWeekendMissionSeasonData;
  const WeekendMissionDetail(
    this.pageItem,
    this.getWeekendMissionSeasonData,
    this.weekendMissionLevelMin,
    this.weekendMissionLevelMax, {
    Key? key,
  }) : super(key: key);

  @override
  _WeekendMissionDetailWidget createState() =>
      _WeekendMissionDetailWidget(pageItem, getWeekendMissionSeasonData);
}

class _WeekendMissionDetailWidget extends State<WeekendMissionDetail>
    with AfterLayoutMixin<WeekendMissionDetail> {
  List<int> isLoadingAdditionalDetails = List.empty(growable: true);
  List<Widget> additionalDetails = List.empty(growable: true);
  WeekendStagePageItem pageItem;
  final Future<ResultWithValue<WeekendStagePageItem>> Function(
          BuildContext context, String seasonId, int level)
      getWeekendMissionSeasonData;

  _WeekendMissionDetailWidget(this.pageItem, this.getWeekendMissionSeasonData) {
    isLoadingAdditionalDetails.add(pageItem.stage.level);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getMissionExtraDetails(context, pageItem.stage.level);
  }

  Future<void> getMission(BuildContext context, int newLevel) async {
    if (newLevel > widget.weekendMissionLevelMax) return;
    if (newLevel < widget.weekendMissionLevelMin) return;
    if (!mounted) return;

    setState(() {
      isLoadingAdditionalDetails.add(newLevel);
    });

    var localWeekendMissionDataResult =
        await getWeekendMissionSeasonData(context, pageItem.season, newLevel);
    if (localWeekendMissionDataResult.hasFailed) return;

    setState(() {
      pageItem = localWeekendMissionDataResult.value;
    });
    await getMissionExtraDetails(context, newLevel);
  }

  Future<void> getMissionExtraDetails(
      BuildContext context, int newLevel) async {
    ResultWithValue<WeekendMissionViewModel> apiResult =
        await getHelloGamesApiService().getWeekendMissionFromSeasonAndLevel(
      pageItem.season,
      newLevel,
    );
    if (!mounted) return;

    if (!apiResult.isSuccess) {
      setState(() {
        isLoadingAdditionalDetails.remove(newLevel);
        additionalDetails = List.empty(growable: true);
      });
      return;
    }

    setState(() {
      isLoadingAdditionalDetails.remove(newLevel);
      if (apiResult.isSuccess &&
          apiResult.value.level == pageItem.stage.level) {
        additionalDetails =
            getAdditionalWidgetsFromVM(context, apiResult.value);
      }
    });
  }

  List<Widget> getAdditionalWidgetsFromVM(
      BuildContext context, WeekendMissionViewModel viewModel) {
    // var isConfirmedByCaptSteve = viewModel.isConfirmedByCaptSteve ?? false;
    // var isConfirmedByAssistantNms =
    //     viewModel.isConfirmedByAssistantNms ?? false;
    var captainSteveVideoUrl = viewModel.captainSteveVideoUrl ?? '';
    return getAdditionalWidgets(
      context,
      captainSteveVideoUrl,
    );
  }

  List<Widget> getAdditionalWidgets(
    BuildContext context,
    String captainSteveVideoUrl,
  ) {
    List<Widget> additionalWidgets = List.empty(growable: true);
    if (captainSteveVideoUrl.isNotEmpty) {
      additionalWidgets.add(const EmptySpace(2));
      additionalWidgets.add(getBaseWidget().customDivider());
      additionalWidgets.add(const EmptySpace1x());
      additionalWidgets.add(GenericItemDescription(
          getTranslations().fromKey(LocaleKey.weekendMissionVideo)));
      additionalWidgets.add(
        Card(
          child: captainSteveYoutubeVideoTile(context, captainSteveVideoUrl),
          margin: EdgeInsets.zero,
        ),
      );
    }
    return additionalWidgets;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List.empty(growable: true);

    if (pageItem.iteration != null) {
      widgets.add(genericItemImage(
        context,
        pageItem.iteration!.icon,
        disableZoom: true,
      ));
    }
    widgets.add(GenericItemDescription(pageItem.stage.npcMessage));

    if (pageItem.stage.npcMessageFlows != null) {
      widgets.add(messageFlowsButton(context, pageItem.stage.npcMessageFlows!));
    }

    if (pageItem.cost != null) {
      widgets.add(const EmptySpace1x());
      widgets.add(getBaseWidget().customDivider());
      widgets.add(const EmptySpace1x());

      widgets.add(GenericItemDescription(
          getTranslations().fromKey(LocaleKey.requiresTheFollowing)));
      widgets.add(FlatCard(
        child: requiredItemDetailsTilePresenter(
          context,
          RequiredItemDetails.fromGenericPageItem(
            pageItem.cost!,
            pageItem.stage.quantity,
          ),
        ),
      ));
    }

    if (pageItem.stage.portalMessageFlows != null) {
      widgets.add(const EmptySpace1x());
      widgets.add(
        messageFlowsButton(context, pageItem.stage.portalMessageFlows!),
      );
    }

    if (isLoadingAdditionalDetails.contains(pageItem.stage.level)) {
      widgets.add(const EmptySpace1x());
      widgets.add(getBaseWidget().customDivider());
      widgets.add(const EmptySpace1x());
      widgets.add(Center(child: getLoading().smallLoadingIndicator()));
    } else {
      widgets.addAll(additionalDetails);
    }

    widgets.add(const EmptySpace1x());
    widgets.add(getBaseWidget().customDivider());
    widgets.add(const EmptySpace1x());

    widgets.add(GenericItemDescription(
      getTranslations().fromKey(LocaleKey.portalAddress),
    ));

    if (pageItem.stage.portalAddress != null) {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: StoreConnector<AppState, PortalGlyphViewModel>(
          converter: (store) => PortalGlyphViewModel.fromStore(store),
          builder: (_, viewModel) => portalGlyphList(
            hexToIntArray(pageItem.stage.portalAddress!),
            6,
            useAltGlyphs: viewModel.useAltGlyphs,
          ),
        ),
      ));
      widgets.add(
        FlatCard(
          child: cyberpunk2350Tile(context,
              subtitle: 'Portal address information discovered by'),
        ),
      );
    }

    widgets.add(const EmptySpace(16));

    var pageContent = ListView(
      children: [
        Padding(
          child: Text(
            pageItem.stage.level.toString(),
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          padding: const EdgeInsets.only(top: 12),
        ),
        ...widgets,
      ],
    );
    // return pageContent;
    return SwipeTo(
      child: dotPagination(
        context,
        content: pageContent,
        currentPosition: pageItem.stage.level - widget.weekendMissionLevelMin,
        numberOfDots:
            (widget.weekendMissionLevelMax - widget.weekendMissionLevelMin) + 1,
        nextLocaleKey: LocaleKey.nextWeekendMission,
        prevLocaleKey: LocaleKey.previousWeekendMission,
        onDotTap: (int dotIndex) => getMission(
          context,
          (dotIndex + widget.weekendMissionLevelMin).toInt(),
        ),
      ),
      offsetDx: 0.5,
      iconSize: 42,
      iconOnRightSwipe: Icons.chevron_left,
      onRightSwipe: (_) => getMission(
        context,
        pageItem.stage.level - 1,
      ),
      iconOnLeftSwipe: Icons.chevron_right,
      onLeftSwipe: (_) => getMission(
        context,
        pageItem.stage.level + 1,
      ),
    );
  }

  Widget messageFlowsButton(BuildContext context, MessageFlow flow) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            getTheme().getSecondaryColour(context),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.chat),
            ),
            Text(getTranslations().fromKey(LocaleKey.readConversation),
                textAlign: TextAlign.center)
          ],
        ),
        onPressed: () {
          adaptiveBottomModalSheet(
            context,
            builder: (context) => WeekendMissionDialogPage(
              flow,
            ),
          );
        },
      ),
    );
  }
}
