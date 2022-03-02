import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/common/image.dart';
import '../../contracts/data/quicksilverStoreItem.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../pages/generic/genericPage.dart';

Widget quicksilverStoreTilePresenter(
    BuildContext context,
    RequiredItemDetails details,
    QuicksilverStoreItem quicksilverItem,
    int currentTier,
    int currentTierPercentage) {
  if (currentTierPercentage == 100) currentTier += 1;

  return gameItemListTileWithSubtitle(
    context,
    leadingImage: details.icon,
    imageGreyScale: quicksilverItem.tier >= currentTier,
    name: details.name,
    subtitle: Text("Tier: ${quicksilverItem.tier}"),
    onTap: () async => await getNavigation().navigateAsync(context,
        navigateTo: (context) => GenericPage(details.id)),
  );
}
