// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/common/image.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/genericPageItem.dart';
import '../../contracts/inventory/inventory.dart';
import '../../contracts/inventory/inventorySlot.dart';
import '../../contracts/redux/appState.dart';
import '../../pages/inventory/addEditInventoryPage.dart';
import '../../redux/modules/inventory/inventorySlotGenericViewModel.dart';
import '../../redux/modules/inventory/inventoryListViewModel.dart';

class AddInventorySlotPage extends StatefulWidget {
  final GenericPageItem genericItem;

  AddInventorySlotPage(this.genericItem, {Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.addInventorySlotPage);
  }

  @override
  createState() => _ViewInventoryListState();
}

class _ViewInventoryListState extends State<AddInventorySlotPage> {
  int _counter = 0;
  Inventory? inventory;
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InventorySlotGenericViewModel>(
      converter: (store) => InventorySlotGenericViewModel.fromStore(store),
      builder: (_, viewModel) => basicGenericPageScaffold(
        context,
        title: getTranslations().fromKey(LocaleKey.inventoryManagement),
        body: getBody(context, viewModel),
        fab: FloatingActionButton(
          onPressed: () async {
            if (inventory == null) return;
            String invUuid = inventory!.uuid;
            InventorySlot invSlot = InventorySlot(
              id: widget.genericItem.id,
              quantity: int.tryParse(quantityController.text) ?? 0,
            );
            viewModel.addInventorySlotToInventory(invUuid, invSlot);
            getNavigation().pop(context);
          },
          heroTag: 'AddInventorySlotPage',
          child: const Icon(Icons.check),
          foregroundColor: getTheme().fabForegroundColourSelector(context),
          backgroundColor: getTheme().fabColourSelector(context),
        ),
      ),
    );
  }

  Widget getBody(BuildContext context, InventorySlotGenericViewModel vm) {
    List<Widget> widgets = List.empty(growable: true);
    widgets.add(vm.displayGenericItemColour
        ? genericItemImageWithBackground(context, widget.genericItem)
        : genericItemImage(context, widget.genericItem.icon));
    bool genericIsNotNull = (widget.genericItem.symbol != null &&
        widget.genericItem.symbol!.isNotEmpty);
    String itemName = genericIsNotNull
        ? "${widget.genericItem.name} (${widget.genericItem.symbol})"
        : widget.genericItem.name;
    widgets.add(GenericItemName(itemName));

    widgets.add(const EmptySpace3x());

    if (vm.containers.isNotEmpty) {
      widgets.add(const GenericItemDescription("Select Container"));
      widgets.add(
        Padding(
          child: DropdownButton<Inventory>(
            hint: const Text("Select item"),
            value: inventory,
            onChanged: (Inventory? value) {
              if (value == null) return;
              setState(() {
                inventory = value;
              });
            },
            items: vm.containers.map((Inventory inv) {
              return DropdownMenuItem<Inventory>(
                value: inv,
                child: Row(
                  children: <Widget>[
                    LocalImage(
                      imagePath:
                          '${getPath().imageAssetPathPrefix}/inventory/${inv.icon}',
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(inv.name),
                  ],
                ),
              );
            }).toList(),
          ),
          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
        ),
      );

      widgets.add(const EmptySpace3x());

      widgets.add(
        Padding(
          child: TextField(
            decoration: InputDecoration(
              labelText: getTranslations().fromKey(LocaleKey.quantity),
            ),
            controller: quantityController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
        ),
      );

      widgets.add(const EmptySpace3x());
    } else {
      widgets.add(GenericItemDescription(
          getTranslations().fromKey(LocaleKey.pleaseAddContainer)));
      widgets.add(Container(
        child: StoreConnector<AppState, InventoryListViewModel>(
          converter: (store) => InventoryListViewModel.fromStore(store),
          builder: (_, viewModel) => PositiveButton(
            title: getTranslations().fromKey(LocaleKey.add),
            onTap: () async {
              Inventory? temp = await getNavigation().navigateAsync<Inventory>(
                context,
                navigateTo: (context) => AddEditInventoryPage(
                  Inventory.initial(),
                  false,
                ),
              );
              if (temp == null) return;
              viewModel.addInventory(temp);
              setState(() {
                _counter++;
              });
            },
          ),
        ),
        margin: const EdgeInsets.all(12),
      ));
    }

    widgets.add(const EmptySpace3x());

    return listWithScrollbar(
      key: Key('stateCounter: $_counter'),
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }
}
