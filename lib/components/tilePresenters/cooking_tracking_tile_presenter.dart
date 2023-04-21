import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/generic_page_item.dart';
import '../../pages/generic/generic_page.dart';

Widget Function(
  BuildContext context,
  GenericPageItem itemDetails, {
  void Function()? onTap,
}) cookingTrackingGridTilePresenter({
  required bool showBackgroundColours,
}) {
  return (
    BuildContext context,
    GenericPageItem itemDetails, {
    void Function()? onTap,
  }) {
    return GestureDetector(
      child: Card(
        child: Column(
          children: [
            LocalImage(imagePath: itemDetails.icon),
            Text(
              itemDetails.name,
              maxLines: 1,
            ),
          ],
        ),
      ),
      onTap: () async => await getNavigation().navigateAsync(
        context,
        navigateTo: (navCtx) => GenericPage(itemDetails.id),
      ),
    );
  };
}
