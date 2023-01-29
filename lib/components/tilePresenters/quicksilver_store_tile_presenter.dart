import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/constants/app_image.dart';
import 'package:flutter/material.dart';

import '../../components/common/image.dart';
import '../../contracts/data/quicksilverStoreItem.dart';
import '../../contracts/required_item_details.dart';
import '../../pages/generic/genericPage.dart';

Widget quicksilverStoreTilePresenter(
    BuildContext context,
    RequiredItemDetails details,
    QuicksilverStoreItem quicksilverItem,
    int currentTier,
    int currentTierPercentage) {
  if (currentTierPercentage == 100) currentTier += 1;

  bool iconIsEmpty = details.icon.isEmpty;
  return gameItemListTileWithSubtitle(
    context,
    leadingImage: iconIsEmpty ? AppImage.unknown : details.icon,
    imageGreyScale: quicksilverItem.tier >= currentTier,
    name: details.name,
    subtitle: Text("Tier: ${quicksilverItem.tier}"),
    onTap: () async => await getNavigation().navigateAsync(
      context,
      navigateTo: (context) => GenericPage(details.id),
    ),
  );
}
