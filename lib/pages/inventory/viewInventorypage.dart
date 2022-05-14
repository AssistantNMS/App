// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/inventoryTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/genericPageItem.dart';
import '../../contracts/inventory/inventory.dart';
import '../../contracts/inventory/inventorySlot.dart';
import '../../contracts/inventory/inventorySlotDetails.dart';
import '../../contracts/inventory/inventorySlotWithGenericPageItem.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/itemsHelper.dart';
import '../../helpers/searchHelpers.dart';
import '../../redux/modules/inventory/inventoryListViewModel.dart';
import '../../redux/modules/inventory/inventorySlotViewModel.dart';
import '../generic/selectGenericItemPage.dart';
import 'AddEditInventoryPage.dart';

class ViewInventoryListPage extends StatefulWidget {
  final String inventoryUuid;
  const ViewInventoryListPage(this.inventoryUuid, {Key key}) : super(key: key);

  @override
  _ViewInventoryListState createState() =>
      _ViewInventoryListState(inventoryUuid);
}

class _ViewInventoryListState extends State<ViewInventoryListPage> {
  final String inventoryUuid;
  int _counter = 0;

  _ViewInventoryListState(this.inventoryUuid) {
    getAnalytics().trackEvent(AnalyticsEvent.viewInventoryPage);
  }

  forceUpdate() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InventoryListViewModel>(
      converter: (store) => InventoryListViewModel.fromStore(store),
      builder: (_, viewModel) {
        for (var container in viewModel.containers) {
          if (container.uuid == inventoryUuid) {
            return getPage(context, viewModel, container);
          }
        }
        return Center(
          child: Text(
            getTranslations().fromKey(LocaleKey.noItems),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }

  Widget getPage(
    BuildContext context,
    InventoryListViewModel listViewmodel,
    Inventory inventory,
  ) {
    return StoreConnector<AppState, InventorySlotViewModel>(
      converter: (store) => InventorySlotViewModel.fromStore(store),
      builder: (_, vm) => basicGenericPageScaffold(
        context,
        title: inventory.name,
        actions: [
          ActionItem(
              icon: Icons.edit,
              onPressed: () async {
                Inventory temp = await getNavigation().navigateAsync<Inventory>(
                  context,
                  navigateTo: (context) =>
                      AddEditInventoryPage(inventory, true),
                );
                if (temp != null) listViewmodel.editInventory(temp);
                forceUpdate();
              }),
        ],
        body: SearchableList<InventorySlotWithGenericPageItem>(
          () => getDetailedInventorySlots(context, inventory.slots),
          listItemDisplayer: inventorySlotInContainerTilePresenter(
            onEdit: (InventorySlot slot) {
              var controller = TextEditingController(
                text: slot.quantity.toString(),
              );
              getDialog().showQuantityDialog(
                context,
                controller,
                onSuccess: (BuildContext ctx, String quantity) {
                  int intQuantity = int.tryParse(quantity);
                  if (intQuantity == null) return;
                  slot.quantity = intQuantity;
                  vm.editInventorySlotInInventory(inventory.uuid, slot);
                },
              );
            },
            onDelete: (InventorySlot slot) =>
                vm.removeInventorySlotFromInventory(inventory.uuid, slot),
          ),
          listItemSearch: searchInventory,
          addFabPadding: true,
          key: Key('numItems: ${inventory.slots.length}, counter: $_counter'),
          minListForSearch: 10,
        ),
        fab: FloatingActionButton(
          onPressed: () async {
            GenericPageItem temp =
                await getNavigation().navigateAsync<GenericPageItem>(
              context,
              navigateTo: (context) => SelectGenericItemPage(inventory.name),
            );
            if (temp == null) return;

            getDialog().showQuantityDialog(context, TextEditingController(),
                title: '', onSuccess: (BuildContext ctx, String quantity) {
              if (quantity == '') return;

              int quantityInt = int.tryParse(quantity);
              InventorySlot inv = InventorySlot(
                  pageItem: InventorySlotDetails.fromGenericPageItem(temp),
                  quantity: quantityInt);

              vm.addInventorySlotToInventory(inventory.uuid, inv);
              forceUpdate();
            });
          },
          heroTag: 'ViewInventoryListPage',
          child: const Icon(Icons.add),
          foregroundColor: getTheme().fabForegroundColourSelector(context),
          backgroundColor: getTheme().fabColourSelector(context),
        ),
      ),
    );
  }
}
