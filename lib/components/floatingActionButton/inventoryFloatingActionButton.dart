import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/genericPageItem.dart';
import '../../pages/inventory/addInventorySlotPage.dart';

Widget inventoryFloatingActionButton(BuildContext context, String uniqueKey,
        TextEditingController controller, GenericPageItem genericItem) =>
    FloatingActionButton(
      onPressed: () async => await getNavigation().navigateAsync(
        context,
        navigateTo: (context) => AddInventorySlotPage(genericItem),
      ),
      tooltip: getTranslations().fromKey(LocaleKey.inventoryManagement),
      heroTag: 'InventoryManagement-$uniqueKey',
      child: getListTileImage('fab/inventory.png'),
      foregroundColor: getTheme().fabForegroundColourSelector(context),
      backgroundColor: getTheme().fabColourSelector(context),
    );

SpeedDialChild inventorySpeedDial(
  BuildContext context,
  GenericPageItem genericItem,
) =>
    SpeedDialChild(
      child: Padding(
        child: getListTileImage('fab/inventory.png'),
        padding: const EdgeInsets.all(8),
      ),
      label: isDesktop
          ? getTranslations().fromKey(LocaleKey.inventoryManagement)
          : null,
      foregroundColor: getTheme().fabForegroundColourSelector(context),
      backgroundColor: getTheme().fabColourSelector(context),
      onTap: () async => await getNavigation().navigateAsync(
        context,
        navigateTo: (context) => AddInventorySlotPage(genericItem),
      ),
    );
