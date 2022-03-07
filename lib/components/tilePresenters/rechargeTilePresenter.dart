import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/NmsUIConstants.dart';
import '../../contracts/chargeBy.dart';
import '../../contracts/genericPageItem.dart';
import '../../contracts/recharge.dart';
import '../../contracts/requiredItem.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../helpers/itemsHelper.dart';
import '../../pages/generic/genericPage.dart';

Widget chargeByItemTilePresenter(
    BuildContext context, ChargeBy recharge, int totalRequired,
    {Function onTap, bool showBackgroundColours = false}) {
  var reqItem = RequiredItem(id: recharge.id, quantity: 0);
  return FutureBuilder<ResultWithValue<RequiredItemDetails>>(
      future: requiredItemDetails(context, reqItem),
      builder: (BuildContext context,
          AsyncSnapshot<ResultWithValue<RequiredItemDetails>> snapshot) {
        Widget errorWidget = asyncSnapshotHandler(
          context,
          snapshot,
          loader: () => getLoading().smallLoadingTile(context),
        );
        if (errorWidget != null) return errorWidget;
        return chargeByItemDetailsTilePresenter(
          context,
          snapshot.data.value,
          recharge,
          totalRequired,
          onTap: onTap,
          showBackgroundColours: showBackgroundColours,
        );
      });
}

Widget chargeByItemDetailsTilePresenter(BuildContext context,
    RequiredItemDetails itemDetails, ChargeBy recharge, int totalRequired,
    {Function onTap, bool showBackgroundColours = false}) {
  String icon = itemDetails.icon;
  Function navigate;
  navigate = (context) => GenericPage(itemDetails.id);

  return genericListTileWithSubtitle(
    context,
    leadingImage: icon,
    name: (totalRequired / recharge.value).toStringAsFixed(0) +
        'x ' +
        itemDetails.name,
    imageBackgroundColour: showBackgroundColours ? itemDetails.colour : null,
    borderRadius: NMSUIConstants.gameItemBorderRadius,
    onTap: onTap ??
        () async =>
            await getNavigation().navigateAsync(context, navigateTo: navigate),
  );
}

Widget usedToRechargeByItemTilePresenter(
    BuildContext context, Recharge recharge, GenericPageItem genericPageItem,
    {Function onTap, bool showBackgroundColours = false}) {
  var reqItem = RequiredItem(id: recharge.id, quantity: 0);
  return FutureBuilder<ResultWithValue<RequiredItemDetails>>(
      future: requiredItemDetails(context, reqItem),
      builder: (BuildContext context,
          AsyncSnapshot<ResultWithValue<RequiredItemDetails>> snapshot) {
        Widget errorWidget = asyncSnapshotHandler(
          context,
          snapshot,
          loader: () => getLoading().smallLoadingTile(context),
        );
        if (errorWidget != null) return errorWidget;
        return usedToRechargeItemDetailsTilePresenter(
          context,
          snapshot.data.value,
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
    GenericPageItem genericPageItem,
    {Function onTap,
    bool showBackgroundColours = false}) {
  String icon = itemDetails.icon;
  Function navigate;
  navigate = (context) => GenericPage(itemDetails.id);

  var chargeByForCurrentItemValue = recharge.chargeBy
      .firstWhere((c) => c.id == genericPageItem.id, orElse: () => ChargeBy())
      .value;

  return genericListTileWithSubtitle(
    context,
    leadingImage: icon,
    name: itemDetails.name,
    subtitle: Text((recharge.totalChargeAmount / chargeByForCurrentItemValue)
            .toStringAsFixed(0) +
        'x ' +
        genericPageItem.name),
    imageBackgroundColour: showBackgroundColours ? itemDetails.colour : null,
    borderRadius: NMSUIConstants.gameItemBorderRadius,
    onTap: onTap ??
        () async =>
            await getNavigation().navigateAsync(context, navigateTo: navigate),
  );
}
