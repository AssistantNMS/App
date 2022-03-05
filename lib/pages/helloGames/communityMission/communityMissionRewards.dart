import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../components/common/image.dart';
import '../../../components/tilePresenters/quicksilverStoreTilePresenter.dart';
import '../../../constants/AppImage.dart';
import '../../../contracts/data/quicksilverStore.dart';
import '../../../contracts/data/quicksilverStoreItem.dart';
import '../../../contracts/requiredItemDetails.dart';
import '../../../helpers/futureHelper.dart';

class CommunityMissionRewards extends StatelessWidget {
  final int missionId;
  final int totalTiers;
  final int currentTier;
  final int currentTierPercentage;
  final QuicksilverStore qsStore;
  final List<RequiredItemDetails> reqItemDetails;

  const CommunityMissionRewards(
    this.missionId, {
    Key key,
    this.totalTiers = 0,
    this.currentTier =
        100, // So that all items displayed in Community mission pages have colour unless it is the current mission
    this.currentTierPercentage = 100,
    this.qsStore,
    this.reqItemDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (qsStore == null || reqItemDetails == null) {
      return FutureBuilder(
        future: quickSilverItemDetailsFuture(context, missionId),
        builder: getBody,
      );
    }
    return getBodyInternal(context, qsStore, reqItemDetails);
  }

  Widget getBody(
      BuildContext bodyContext,
      AsyncSnapshot<
              ResultWithDoubleValue<QuicksilverStore,
                  List<RequiredItemDetails>>>
          snapshot) {
    Widget errorWidget = asyncSnapshotHandler(bodyContext, snapshot,
        isValidFunction:
            (ResultWithDoubleValue<QuicksilverStore, List<RequiredItemDetails>>
                data) {
      if (snapshot.data.value == null ||
          snapshot.data.value.items == null ||
          snapshot.data.value.missionId == null) {
        return false;
      }
      return true;
    });
    if (errorWidget != null) return errorWidget;
    return getBodyInternal(
      bodyContext,
      snapshot.data.value,
      snapshot.data.secondValue,
    );
  }

  Widget getBodyInternal(BuildContext internalContext, QuicksilverStore qsStore,
      List<RequiredItemDetails> reqItemDetails) {
    List<Widget> widgets = List.empty(growable: true);

    if (totalTiers <= 0 || totalTiers == qsStore.items.length) {
      if (reqItemDetails.isEmpty) {
        for (var qs = 0; qs < qsStore.items.length; qs++) {
          widgets.add(genericListTile(
            internalContext,
            leadingImage: AppImage.unknown,
            name: getTranslations().fromKey(LocaleKey.unknown),
          ));
        }
      }
      for (RequiredItemDetails reqDetails in reqItemDetails) {
        QuicksilverStoreItem itemFound =
            qsStore.items.firstWhere((item) => item.itemId == reqDetails.id);
        if (itemFound == null) continue;

        widgets.add(quicksilverStoreTilePresenter(
          internalContext,
          reqDetails,
          itemFound,
          currentTier,
          currentTierPercentage,
        ));
      }
    } else {
      widgets.add(genericItemImage(internalContext, AppImage.error));
      widgets.add(genericItemDescription(
        getTranslations().fromKey(LocaleKey.communityMissionMismatchTitle),
      ));
      widgets.add(genericItemDescription(
        getTranslations().fromKey(LocaleKey.communityMissionMismatchMessage),
      ));
    }

    return animateWidgetIn(
      child: Column(children: widgets),
    );
  }
}
