import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../components/common/image.dart';
import '../../../components/tilePresenters/quicksilver_store_tile_presenter.dart';
import '../../../components/tilePresenters/required_item_details_tile_presenter.dart';
import '../../../constants/app_image.dart';
import '../../../contracts/data/quicksilverStore.dart';
import '../../../contracts/data/quicksilverStoreItem.dart';
import '../../../contracts/enum/community_mission_status.dart';
import '../../../contracts/helloGames/quickSilverStoreDetails.dart';
import '../../../contracts/requiredItemDetails.dart';
import '../../../helpers/futureHelper.dart';
import 'community_mission_extra_data.dart';

class CommunityMissionRewards extends StatelessWidget {
  final int missionId;
  final int totalTiers;
  final int currentTier;
  final int currentTierPercentage;
  final QuicksilverStore? qsStore;
  final CommunityMissionStatus status;
  final List<RequiredItemDetails>? itemDetails;
  final List<RequiredItemDetails>? requiredItemDetails;

  const CommunityMissionRewards(
    this.missionId,
    this.status, {
    Key? key,
    this.totalTiers = 0,
    this.currentTier =
        100, // So that all items displayed in Community mission pages have colour unless it is the current mission
    this.currentTierPercentage = 100,
    this.qsStore,
    this.itemDetails,
    this.requiredItemDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (qsStore == null || itemDetails == null) {
      return FutureBuilder(
        future: quickSilverItemDetailsFuture(context, missionId),
        builder: getBody,
      );
    }
    return getBodyInternal(
      context,
      qsStore!,
      itemDetails!,
      requiredItemDetails,
    );
  }

  Widget getBody(
    BuildContext bodyContext,
    AsyncSnapshot<ResultWithValue<QuicksilverStoreDetails>> snapshot,
  ) {
    Widget? errorWidget = asyncSnapshotHandler(bodyContext, snapshot,
        isValidFunction: (ResultWithValue<QuicksilverStoreDetails>? data) {
      if (snapshot.data == null ||
          snapshot.data?.value == null ||
          snapshot.data?.value.items == null ||
          snapshot.data?.value.store.missionId == null) {
        return false;
      }
      return true;
    });
    if (errorWidget != null) return errorWidget;
    return getBodyInternal(
      bodyContext,
      snapshot.data!.value.store,
      snapshot.data!.value.items,
      snapshot.data!.value.itemsRequired,
    );
  }

  Widget getBodyInternal(
    BuildContext internalContext,
    QuicksilverStore qsStore,
    List<RequiredItemDetails> itemDetails,
    List<RequiredItemDetails>? requiredItemDetails,
  ) {
    List<Widget> widgets = List.empty(growable: true);
    bool tiersAreValid = totalTiers <= 0 || totalTiers == qsStore.items.length;
    bool isSpecialQsMission =
        qsStore.icon.isNotEmpty && qsStore.name.isNotEmpty;
    if (tiersAreValid == false && isSpecialQsMission == false) {
      widgets.add(genericItemImage(internalContext, AppImage.error));
      widgets.add(GenericItemDescription(
        getTranslations().fromKey(LocaleKey.communityMissionMismatchTitle),
      ));
      widgets.add(GenericItemDescription(
        getTranslations().fromKey(LocaleKey.communityMissionMismatchMessage),
      ));
    } else {
      if (!isSpecialQsMission) {
        if (itemDetails.isEmpty) {
          for (int qs = 0; qs < qsStore.items.length; qs++) {
            widgets.add(genericListTile(
              internalContext,
              leadingImage: AppImage.unknown,
              name: getTranslations().fromKey(LocaleKey.unknown),
            ));
          }
        }

        for (RequiredItemDetails itemDetails in itemDetails) {
          QuicksilverStoreItem? itemFound = qsStore.items.firstWhereOrNull(
            (item) => item.itemId == itemDetails.id,
          );
          if (itemFound == null) continue;

          widgets.add(quicksilverStoreTilePresenter(
            internalContext,
            itemDetails,
            itemFound,
            currentTier,
            currentTierPercentage,
          ));
        }
      } else {
        Widget topElement = FlatCard(
          child: genericListTileWithSubtitle(
            internalContext,
            leadingImage: qsStore.icon,
            name: qsStore.name,
            subtitle: Text(
              getTranslations().fromKey(LocaleKey.communityMission),
            ),
          ),
        );
        List<Widget> requiredItemsWidgets = List.empty(growable: true);
        List<RequiredItemDetails> reqItemsToDisplay =
            requiredItemDetails ?? List.empty();
        requiredItemsWidgets.add(const EmptySpace1x());
        if (reqItemsToDisplay.isNotEmpty) {
          requiredItemsWidgets.add(topElement);
          requiredItemsWidgets.add(const EmptySpace1x());
          requiredItemsWidgets.add(GenericItemDescription(
            getTranslations().fromKey(LocaleKey.requiresTheFollowing),
          ));

          for (RequiredItemDetails itemDetails in reqItemsToDisplay) {
            requiredItemsWidgets.add(requiredItemDetailsTilePresenter(
              internalContext,
              itemDetails,
            ));
          }
          requiredItemsWidgets.add(const EmptySpace1x());

          widgets.add(Column(
            children: requiredItemsWidgets,
          ));
        } else {
          widgets.add(topElement);
        }
      }
    }

    if (qsStore.items.isEmpty && isSpecialQsMission == false) {
      widgets.addAll(
        [
          const EmptySpace3x(),
          GenericItemName(getTranslations().fromKey(LocaleKey.noItems)),
        ],
      );
    }

    widgets.add(CommunityMissionExtraData(missionId, status));

    return animateWidgetIn(
      child: Column(children: widgets),
    );
  }
}
