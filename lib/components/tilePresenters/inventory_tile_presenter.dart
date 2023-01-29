import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/inventory/inventory.dart';
import '../../contracts/inventory/inventory_slot.dart';
import '../../contracts/inventory/inventory_slot_with_container_and_generic_page_item.dart';
import '../../contracts/inventory/inventory_slot_with_generic_page_item.dart';
import '../../contracts/required_item_details.dart';
import '../../helpers/generic_helper.dart';

import '../../pages/generic/generic_page.dart';
import '../../pages/inventory/view_inventory_page.dart';
import 'required_item_tile_presenter.dart';

Widget inventoryTilePresenter(
  BuildContext context,
  Inventory inventory, {
  void Function()? onTap,
  void Function()? onEdit,
  void Function()? onDelete,
}) =>
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
  BuildContext innerContext,
  String icon,
  Function(String icon) onTap,
) =>
    gridIconTilePresenter(innerContext, 'inventory/', icon, onTap);

List<Widget> Function(
  BuildContext context,
  Inventory inventory,
) inventoryContainsItemTilePresenter(
  BuildContext context,
  String itemId,
) =>
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
          quantity: (slot.quantity > 0) ? slot.quantity : 0,
          onTap: () => getNavigation().navigateAsync(context,
              navigateTo: (context) => ViewInventoryListPage(inventory.uuid)),
          // onTap: onTap ?? () {},
        ));
      }
      return result;
    };

Widget Function(BuildContext context, InventorySlotWithGenericPageItem invSlot,
    {void Function()? onTap}) inventorySlotInContainerTilePresenter({
  required void Function(InventorySlot) onEdit,
  required void Function(InventorySlot) onDelete,
}) {
  return (BuildContext context, InventorySlotWithGenericPageItem invSlot,
      {void Function()? onTap}) {
    return genericItemTilePresenterWrapper(
      context,
      appId: invSlot.id,
      builder: (BuildContext innerCtx, RequiredItemDetails details) {
        InventorySlotWithGenericPageItem updatedInv =
            InventorySlotWithGenericPageItem(
          id: details.id,
          icon: details.icon,
          name: details.name,
          quantity: invSlot.quantity,
        );
        return genericListTile(
          context,
          leadingImage: updatedInv.icon,
          name: updatedInv.name,
          quantity: updatedInv.quantity,
          trailing: popupMenu(
            context,
            onEdit: () => onEdit(updatedInv),
            onDelete: () => onDelete(updatedInv),
          ),
          onTap: () async => await getNavigation().navigateAwayFromHomeAsync(
            context,
            navigateTo: (context) => GenericPage(updatedInv.id),
          ),
        );
      },
    );
  };
}

Widget inventorySlotTileWithContainersPresenter(
  BuildContext context,
  InventorySlotWithContainersAndGenericPageItem invSlot, {
  void Function()? onTap,
}) {
  return genericItemTilePresenterWrapper(
    context,
    appId: invSlot.id,
    builder: (BuildContext innerCtx, RequiredItemDetails details) {
      Widget? trailingWidget;

      if (invSlot.containers.isNotEmpty) {
        void Function(String invContainerId) trailingOnPress;
        trailingOnPress = (String invContainerId) =>
            getNavigation().navigateAwayFromHomeAsync(
              context,
              navigateTo: (context) => ViewInventoryListPage(
                invContainerId,
              ),
            );

        trailingWidget = popupMenu(
          context,
          additionalItems: invSlot.containers
              .map(
                (invContainer) => PopupMenuActionItem(
                  text: invContainer.name,
                  icon: Icons.open_in_new,
                  image: ListTileImage(
                    partialPath:
                        // ignore: unnecessary_null_comparison
                        invContainer.icon != null
                            ? 'inventory/${invContainer.icon}'
                            : 'drawer/inventory.png',
                  ),
                  onPressed: () => trailingOnPress(invContainer.id),
                ),
              )
              .toList(),
        );
      }

      return genericListTileWithSubtitle(
        context,
        leadingImage: details.icon,
        name: details.name,
        subtitle: Text(
          '${invSlot.quantity.toString()} - ${joinStringList(invSlot.containers.map((i) => i.name).toList(), ', ')}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: trailingWidget,
        onTap: () async => await getNavigation().navigateAwayFromHomeAsync(
          context,
          navigateTo: (context) => GenericPage(invSlot.id),
        ),
      );
    },
  );
}
