// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/requiredItemDetailsTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/enum/currencyType.dart';
import '../../contracts/genericPageAllRequired.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../contracts/requiredItemTreeDetails.dart';
import '../../helpers/genericHelper.dart';
import '../../helpers/itemsHelper.dart';
import 'genericPageAllRequiredRawMaterialsTreeComponents.dart';

class GenericPageAllRequiredRawMaterials extends StatefulWidget {
  final GenericPageAllRequired item;
  final bool showBackgroundColours;
  const GenericPageAllRequiredRawMaterials(
      this.item, this.showBackgroundColours,
      {Key key})
      : super(key: key);

  @override
  _GenericPageAllRequiredRawMaterialsWidget createState() =>
      _GenericPageAllRequiredRawMaterialsWidget(item, showBackgroundColours);
}

class _GenericPageAllRequiredRawMaterialsWidget
    extends State<GenericPageAllRequiredRawMaterials> {
  final GenericPageAllRequired item;
  final bool showBackgroundColours;
  int currentSelection = 0;

  _GenericPageAllRequiredRawMaterialsWidget(
      this.item, this.showBackgroundColours) {
    getAnalytics()
        .trackEvent(AnalyticsEvent.genericAllRequiredRawMaterialsPage);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    List<Widget> options = [
      getSegmentedControlWithIconOption(
        Icons.list,
        getTranslations().fromKey(LocaleKey.flatList),
      ),
      getSegmentedControlWithIconOption(
        Icons.call_split,
        getTranslations().fromKey(LocaleKey.tree),
      )
    ];
    Container segmentedWidget = Container(
      child: adaptiveSegmentedControl(context,
          controlItems: options,
          currentSelection: currentSelection, onSegmentChosen: (index) {
        setState(() {
          currentSelection = index;
        });
      }),
      margin: const EdgeInsets.all(8),
    );

    return basicGenericPageScaffold(
      context,
      title: item.typeName ?? getTranslations().fromKey(LocaleKey.loading),
      body: getBody(context, currentSelection, segmentedWidget),
      fab: getFloatingActionButton(context, controller, item.genericItem),
    );
  }

  List<Widget> getFlatListBody(
    BuildContext context,
    AsyncSnapshot<List<RequiredItemDetails>> snapshot,
  ) {
    Widget errorWidget = asyncSnapshotHandler(context, snapshot);
    if (errorWidget != null) return [errorWidget];

    List<Widget> widgets = List.empty(growable: true);

    Widget Function(BuildContext context, RequiredItemDetails itemDetails)
        requiredItemDetailsPresenter =
        requiredItemDetailsBackgroundTilePresenter(showBackgroundColours);
    if (snapshot.data.isNotEmpty) {
      for (RequiredItemDetails item in snapshot.data) {
        widgets.add(requiredItemDetailsPresenter(context, item));
      }
    } else {
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
    }

    widgets.add(emptySpace8x());

    return widgets;
  }

  List<Widget> getTreeBody(
    BuildContext context,
    AsyncSnapshot<List<RequiredItemTreeDetails>> snapshot,
  ) {
    Widget errorWidget = asyncSnapshotHandler(context, snapshot);
    if (errorWidget != null) return [errorWidget];

    List<Widget> widgets = List.empty(growable: true);

    if (snapshot.data.isNotEmpty) {
      widgets.add(Expanded(
        child: ListView(
          shrinkWrap: true,
          children: [
            getTree(context, snapshot.data, CurrencyType.NONE),
          ],
        ),
      ));
    } else {
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
    }

    return widgets;
  }

  Widget getBody(
    BuildContext context,
    int currentSelection,
    Widget segmentedWidget,
  ) {
    List<Widget> widgets = List.empty(growable: true);
    if (item.name.isNotEmpty) {
      widgets.add(emptySpace1x());
      widgets.add(genericItemName(item.name));
      widgets.add(genericItemText(
        getTranslations().fromKey(LocaleKey.allRawMaterialsRequired),
      ));
    }

    widgets.add(segmentedWidget);

    if (currentSelection == 0) {
      return FutureBuilder<List<RequiredItemDetails>>(
        future: getAllRequiredItemsForMultiple(context, item.requiredItems),
        builder: (BuildContext builderContext,
            AsyncSnapshot<List<RequiredItemDetails>> snapshot) {
          List<Widget> listSpecificWidgets = [
            ...widgets,
            ...getFlatListBody(builderContext, snapshot)
          ];
          return Column(
            children: [
              Expanded(
                child: listWithScrollbar(
                  itemCount: listSpecificWidgets.length,
                  itemBuilder: (builderContext, index) =>
                      listSpecificWidgets[index],
                ),
              ),
            ],
          );
        },
      );
    } else {
      return FutureBuilder<List<RequiredItemTreeDetails>>(
        future: getAllRequiredItemsForTree(context, item.requiredItems),
        builder: (BuildContext builderContext,
            AsyncSnapshot<List<RequiredItemTreeDetails>> snapshot) {
          var treeSpecificWidgets = [
            ...widgets,
            ...getTreeBody(builderContext, snapshot)
          ];
          return Column(
            children: treeSpecificWidgets,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          );
        },
      );
    }
  }
}
