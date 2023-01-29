import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../constants/nms_ui_constants.dart';
import '../../contracts/charge_by.dart';
import '../../contracts/generic_page_item.dart';
import '../../contracts/recharge.dart';
import '../../contracts/required_item.dart';
import '../../contracts/required_item_details.dart';
import '../../helpers/items_helper.dart';
import '../../pages/generic/generic_page.dart';

Widget chargeByItemTilePresenter(
  BuildContext context,
  ChargeBy recharge,
  int totalRequired, {
  void Function()? onTap,
  bool showBackgroundColours = false,
}) {
  var reqItem = RequiredItem(id: recharge.id, quantity: 0);
  return FutureBuilder<ResultWithValue<RequiredItemDetails>>(
      future: requiredItemDetails(context, reqItem),
      builder: (BuildContext context,
          AsyncSnapshot<ResultWithValue<RequiredItemDetails>> snapshot) {
        Widget? errorWidget = asyncSnapshotHandler(
          context,
          snapshot,
          loader: () => getLoading().smallLoadingTile(context),
        );
        if (errorWidget != null) return errorWidget;
        return chargeByItemDetailsTilePresenter(
          context,
          snapshot.data!.value,
          recharge,
          totalRequired,
          onTap: onTap,
          showBackgroundColours: showBackgroundColours,
        );
      });
}

Widget chargeByItemDetailsTilePresenter(
  BuildContext context,
  RequiredItemDetails itemDetails,
  ChargeBy recharge,
  int totalRequired, {
  void Function()? onTap,
  bool showBackgroundColours = false,
}) {
  String icon = itemDetails.icon;

  return genericListTileWithSubtitle(
    context,
    leadingImage: icon,
    name: (totalRequired / recharge.value).toStringAsFixed(0) +
        'x ' +
        itemDetails.name,
    imageBackgroundColour: showBackgroundColours ? itemDetails.colour : null,
    borderRadius: NMSUIConstants.gameItemBorderRadius,
    onTap: onTap ??
        () async => await getNavigation().navigateAsync(
              context,
              navigateTo: (context) => GenericPage(itemDetails.id),
            ),
  );
}

Widget usedToRechargeByItemTilePresenter(
  BuildContext context,
  Recharge recharge,
  GenericPageItem genericPageItem, {
  void Function()? onTap,
  bool showBackgroundColours = false,
}) {
  RequiredItem reqItem = RequiredItem(id: recharge.id, quantity: 0);
  return FutureBuilder<ResultWithValue<RequiredItemDetails>>(
      future: requiredItemDetails(context, reqItem),
      builder: (BuildContext context,
          AsyncSnapshot<ResultWithValue<RequiredItemDetails>> snapshot) {
        Widget? errorWidget = asyncSnapshotHandler(
          context,
          snapshot,
          loader: () => getLoading().smallLoadingTile(context),
        );
        if (errorWidget != null) return errorWidget;
        return usedToRechargeItemDetailsTilePresenter(
          context,
          snapshot.data!.value,
          recharge,
          genericPageItem,
          onTap: onTap,
          showBackgroundColours: showBackgroundColours,
        );
      });
}

Widget usedToRechargeItemDetailsTilePresenter(
  BuildContext context,
  RequiredItemDetails itemDetails,
  Recharge recharge,
  GenericPageItem genericPageItem, {
  void Function()? onTap,
  bool showBackgroundColours = false,
}) {
  String icon = itemDetails.icon;

  var chargeByForCurrentItemValue = recharge.chargeBy
      .firstWhereOrNull(
        (c) => c.id == genericPageItem.id,
      )
      ?.value;

  return genericListTileWithSubtitle(
    context,
    leadingImage: icon,
    name: itemDetails.name,
    subtitle: Text(
        (recharge.totalChargeAmount / (chargeByForCurrentItemValue ?? 1))
                .toStringAsFixed(0) +
            'x ' +
            genericPageItem.name),
    imageBackgroundColour: showBackgroundColours ? itemDetails.colour : null,
    borderRadius: NMSUIConstants.gameItemBorderRadius,
    onTap: onTap ??
        () async => await getNavigation().navigateAsync(
              context,
              navigateTo: (context) => GenericPage(itemDetails.id),
            ),
  );
}
