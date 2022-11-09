import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/inventoryTilePresenter.dart';
import '../../components/tilePresenters/youtubersTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/UserSelectionIcons.dart';
import '../../contracts/inventory/inventory.dart';
import '../../contracts/inventory/inventoryOrderByType.dart';
import '../../contracts/redux/appState.dart';
import '../../redux/modules/inventory/inventoryListViewModel.dart';
import 'addEditInventoryPage.dart';
import 'searchAllInventoriesPage.dart';
import 'viewInventoryPage.dart';

class InventoryListPage extends StatefulWidget {
  const InventoryListPage({Key key}) : super(key: key);

  @override
  _InventoryListState createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryListPage> {
  int _counter = 0;
  _InventoryListState() {
    getAnalytics().trackEvent(AnalyticsEvent.inventoryListPage);
  }

  forceUpdate() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget Function(InventoryListViewModel vm) appBar;
    appBar = (InventoryListViewModel vm) => getBaseWidget().appBarForSubPage(
          context,
          showHomeAction: true,
          title: Text(getTranslations().fromKey(LocaleKey.inventoryManagement)),
          actions: [
            ActionItem(
              icon: Icons.sort,
              onPressed: () async {
                List<DropdownOption> options = List.empty(growable: true);
                options.add(DropdownOption(
                  getTranslations()
                      .fromKey(getOrderByLocale(InventoryOrderByType.name)),
                  value:
                      EnumToString.convertToString(InventoryOrderByType.name),
                ));
                options.add(DropdownOption(
                  getTranslations()
                      .fromKey(getOrderByLocale(InventoryOrderByType.icons)),
                  value:
                      EnumToString.convertToString(InventoryOrderByType.icons),
                ));

                String temp = await getNavigation().navigateAsync(
                  context,
                  navigateTo: (context) => OptionsListPageDialog(
                      getTranslations().fromKey(LocaleKey.orderBy), options),
                );
                var result = (temp == null || temp.isEmpty) ? '' : temp;
                InventoryOrderByType orderByType = EnumToString.fromString(
                    InventoryOrderByType.values, result);
                vm.setOrderByType(orderByType);
              },
            )
          ],
        );
    return StoreConnector<AppState, InventoryListViewModel>(
      converter: (store) => InventoryListViewModel.fromStore(store),
      builder: (_, viewModel) => basicGenericPageScaffold(
        context,
        appBar: appBar(viewModel),
        body: getBody(context, viewModel),
        fab: FloatingActionButton(
          onPressed: () async {
            Inventory temp = await getNavigation().navigateAsync<Inventory>(
              context,
              navigateTo: (context) => AddEditInventoryPage(Inventory(), false),
            );
            if (temp == null) return;
            viewModel.addInventory(temp);
            forceUpdate();
          },
          heroTag: 'InventoryListPage',
          child: const Icon(Icons.add),
          foregroundColor: getTheme().fabForegroundColourSelector(context),
          backgroundColor: getTheme().fabColourSelector(context),
        ),
      ),
    );
  }

  Widget getBody(BuildContext context, InventoryListViewModel viewModel) {
    List<Widget> widgets = List.empty(growable: true);

    if (viewModel.containers.isEmpty) {
      widgets.add(
        Container(
          child: Text(
            getTranslations().fromKey(LocaleKey.noItems),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20),
          ),
          margin: const EdgeInsets.only(top: 30),
        ),
      );
      widgets.add(emptySpace3x());
    } else {
      widgets.add(Padding(
        child: Card(
          child: InkWell(
            child: Padding(
              child: Center(
                child: Icon(
                  Icons.search,
                  color: getTheme().getSecondaryColour(context),
                ),
              ),
              padding: const EdgeInsets.all(12),
            ),
            onTap: () async => await getNavigation().navigateAsync<Inventory>(
              context,
              navigateTo: (context) => SearchAllInventoriesPage(),
            ),
          ),
        ),
        padding: const EdgeInsets.only(top: 4, bottom: 0),
      ));
      widgets.addAll(getContainers(viewModel));
    }

    widgets.add(Card(
      child: nomNomOpenSyncModalTile(
        context,
        viewModel.isPatron,
      ),
    ));

    widgets.add(emptySpace10x());

    return listWithScrollbar(
      key: Key('counter: $_counter'),
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  List<Inventory> getSortedContainers(InventoryListViewModel viewModel) {
    switch (viewModel.orderByType) {
      case InventoryOrderByType.icons:
        viewModel.containers.sort((a, b) => UserSelectionIcons.inventory
            .indexOf(a.icon)
            .compareTo(UserSelectionIcons.inventory.indexOf(b.icon)));
        return viewModel.containers;
      case InventoryOrderByType.name:
      default:
        viewModel.containers.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        return viewModel.containers;
    }
  }

  List<Widget> getContainers(InventoryListViewModel viewModel) {
    List<Widget> containerWidgets = List.empty(growable: true);
    for (Inventory container in getSortedContainers(viewModel)) {
      containerWidgets.add(inventoryTilePresenter(
        context,
        container,
        onTap: () => getNavigation().navigateAsync(context,
            navigateTo: (context) => ViewInventoryListPage(container.uuid)),
        onEdit: () async {
          Inventory temp = await getNavigation().navigateAsync<Inventory>(
            context,
            navigateTo: (context) => AddEditInventoryPage(container, true),
          );
          if (temp != null) viewModel.editInventory(temp);
          forceUpdate();
        },
        onDelete: () => viewModel.removeInventory(container.uuid),
      ));
    }
    return containerWidgets;
  }
}
