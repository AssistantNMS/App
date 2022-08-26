import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/inventory/inventory.dart';
import '../../contracts/inventory/inventorySlot.dart';
import '../../contracts/inventory/inventorySlotWithContainerAndGenericPageItem.dart';
import '../../contracts/inventory/inventorySlotWithGenericPageItem.dart';
import '../../helpers/genericHelper.dart';

import '../../pages/generic/genericPage.dart';
import '../../pages/inventory/viewInventorypage.dart';

Widget inventoryTilePresenter(BuildContext context, Inventory inventory,
        {Function onTap, Function onEdit, Function onDelete}) =>
    Card(
      child: genericListTileWithSubtitle(
        context,
        leadingImage: 'inventory/${inventory.icon}',
        name: inventory.name,
        subtitle: Text(
          getTranslations().fromKey(LocaleKey.numberOfSlots).replaceAll(
                '{0}',
                inventory.slots.length.toString(),
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: popupMenu(context, onEdit: onEdit, onDelete: onDelete),
        onTap: onTap ?? () {},
      ),
    );

Widget inventoryIconTilePresenter(
        BuildContext innerContext, String icon, Function(String icon) onTap) =>
    gridIconTilePresenter(innerContext, 'inventory/', icon, onTap);

List<Widget> Function(BuildContext context,
    Inventory inventory) inventoryContainsItemTilePresenter(
        BuildContext context, String itemId) =>
    (BuildContext context, Inventory inventory) {
      List<InventorySlot> slots = inventory.slots
          .where((InventorySlot slot) => slot.id == itemId)
          .toList();
      List<Widget> result = List.empty(growable: true);
      for (var slot in slots) {
        result.add(genericListTile(
          context,
          leadingImage: 'inventory/${inventory.icon}',
          name: inventory.name,
          quantity: (slot != null && slot.quantity > 0) ? slot.quantity : 0,
          onTap: () => getNavigation().navigateAsync(context,
              navigateTo: (context) => ViewInventoryListPage(inventory.uuid)),
          // onTap: onTap ?? () {},
        ));
      }
      return result;
    };

Widget inventorySlotTilePresenter(BuildContext context, String containerName,
        InventorySlotWithGenericPageItem invSlot) =>
    genericListTileWithSubtitle(
      context,
      leadingImage: invSlot.icon,
      name: invSlot.name,
      subtitle: Text(
        containerName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () async => await getNavigation().navigateAwayFromHomeAsync(
        context,
        navigateTo: (context) => GenericPage(invSlot.id),
      ),
    );
/*

Widget Function(BuildContext context,
    Inventory inventory) inventoryContainsItemTilePresenter(
        BuildContext context, String itemId) =>
    (BuildContext context, Inventory inventory) {

 */
Widget Function(BuildContext context, InventorySlotWithGenericPageItem invSlot)
    inventorySlotInContainerTilePresenter(
            {Function onEdit, Function onDelete}) =>
        (BuildContext context, InventorySlotWithGenericPageItem invSlot) =>
            genericListTile(
              context,
              leadingImage: invSlot.icon,
              name: invSlot.name ?? 'unknown',
              quantity: invSlot.quantity,
              trailing: popupMenu(
                context,
                onEdit: () => onEdit(invSlot),
                onDelete: () => onDelete(invSlot),
              ),
              onTap: () async =>
                  await getNavigation().navigateAwayFromHomeAsync(
                context,
                navigateTo: (context) => GenericPage(invSlot.id),
              ),
            );

Widget inventorySlotTileWithContainersPresenter(
  BuildContext context,
  InventorySlotWithContainersAndGenericPageItem invSlot,
) =>
    genericListTileWithSubtitle(
      context,
      leadingImage: invSlot.icon,
      name: invSlot.name ?? 'test',
      subtitle: Text(
        '${invSlot.quantity.toString()} - ${joinStringList(invSlot.containers.map((i) => i.name).toList(), ', ')}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () async => await getNavigation().navigateAwayFromHomeAsync(
        context,
        navigateTo: (context) => GenericPage(invSlot.id),
      ),
      trailing: (invSlot == null ||
              invSlot.containers == null ||
              invSlot.containers.isEmpty)
          ? null
          : popupMenu(context,
              additionalItems: invSlot.containers
                  .map(
                    (i) => PopupMenuActionItem(
                      text: i.name,
                      icon: Icons.open_in_new,
                      image: getListTileImage(
                        i.icon != null
                            ? 'inventory/${i.icon}'
                            : 'drawer/inventory.png',
                      ),
                      onPressed: () async =>
                          await getNavigation().navigateAwayFromHomeAsync(
                        context,
                        navigateTo: (context) => ViewInventoryListPage(i.id),
                      ),
                    ),
                  )
                  .toList()),
    );
