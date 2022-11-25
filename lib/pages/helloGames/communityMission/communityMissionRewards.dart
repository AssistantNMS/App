import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../components/common/image.dart';
import '../../../components/tilePresenters/quicksilverStoreTilePresenter.dart';
import '../../../components/tilePresenters/requiredItemDetailsTilePresenter.dart';
import '../../../constants/AppImage.dart';
import '../../../contracts/data/quicksilverStore.dart';
import '../../../contracts/data/quicksilverStoreItem.dart';
import '../../../contracts/helloGames/quickSilverStoreDetails.dart';
import '../../../contracts/requiredItemDetails.dart';
import '../../../helpers/futureHelper.dart';

class CommunityMissionRewards extends StatelessWidget {
  final int missionId;
  final int totalTiers;
  final int currentTier;
  final int currentTierPercentage;
  final QuicksilverStore qsStore;
  final List<RequiredItemDetails> itemDetails;
  final List<RequiredItemDetails> requiredItemDetails;

  const CommunityMissionRewards(
    this.missionId, {
    Key key,
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
    return getBodyInternal(context, qsStore, itemDetails, requiredItemDetails);
  }

  Widget getBody(BuildContext bodyContext,
      AsyncSnapshot<ResultWithValue<QuicksilverStoreDetails>> snapshot) {
    Widget errorWidget = asyncSnapshotHandler(bodyContext, snapshot,
        isValidFunction: (ResultWithValue<QuicksilverStoreDetails> data) {
      if (snapshot.data.value == null ||
          snapshot.data.value.items == null ||
          snapshot.data.value.store.missionId == null) {
        return false;
      }
      return true;
    });
    if (errorWidget != null) return errorWidget;
    return getBodyInternal(
      bodyContext,
      snapshot.data.value.store,
      snapshot.data.value.items,
      snapshot.data.value.itemsRequired,
    );
  }

  Widget getBodyInternal(
    BuildContext internalContext,
    QuicksilverStore qsStore,
    List<RequiredItemDetails> itemDetails,
    List<RequiredItemDetails> requiredItemDetails,
  ) {
    List<Widget> widgets = List.empty(growable: true);
    bool tiersAreValid = totalTiers <= 0 || totalTiers == qsStore.items.length;
    bool isSpecialQsMission =
        qsStore.icon.isNotEmpty && qsStore.name.isNotEmpty;
    if (tiersAreValid == false && isSpecialQsMission == false) {
      widgets.add(genericItemImage(internalContext, AppImage.error));
      widgets.add(genericItemDescription(
        getTranslations().fromKey(LocaleKey.communityMissionMismatchTitle),
      ));
      widgets.add(genericItemDescription(
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

        for (RequiredItemDetails itemDetails in itemDetails ?? List.empty()) {
          QuicksilverStoreItem itemFound = qsStore.items.firstWhere(
            (item) => item.itemId == itemDetails.id,
            orElse: () => null,
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
        Widget topElement = flatCard(
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
        requiredItemsWidgets.add(emptySpace1x());
        if (reqItemsToDisplay.isNotEmpty) {
          requiredItemsWidgets.add(topElement);
          requiredItemsWidgets.add(emptySpace1x());
          requiredItemsWidgets.add(genericItemDescription(
            getTranslations().fromKey(LocaleKey.requiresTheFollowing),
          ));

          for (RequiredItemDetails itemDetails in reqItemsToDisplay) {
            requiredItemsWidgets.add(requiredItemDetailsTilePresenter(
              internalContext,
              itemDetails,
            ));
          }
          requiredItemsWidgets.add(emptySpace1x());

          widgets.add(Column(
            children: requiredItemsWidgets,
          ));
        } else {
          widgets.add(topElement);
        }
      }
    }

    if (qsStore.items.isEmpty) {
      widgets.addAll(
        [
          emptySpace3x(),
          genericItemName(getTranslations().fromKey(LocaleKey.noItems)),
        ],
      );
    }

    return animateWidgetIn(
      child: Column(children: widgets),
    );
  }
}
