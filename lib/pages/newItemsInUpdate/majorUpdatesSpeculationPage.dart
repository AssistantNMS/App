import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../contracts/data/majorUpdateItem.dart';

const millisecondsToDaysConversion = 86400000;

class MajorUpdatesSpeculationPage extends StatelessWidget {
  final List<MajorUpdateItem> items;
  const MajorUpdatesSpeculationPage({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: 'Speculation', // TODO translate
      body: getBody(context, items),
    );
  }

  Widget getBody(
    BuildContext bodyCtx,
    List<MajorUpdateItem> localMajorItems,
  ) {
    List<Widget> listItems = List.empty(growable: true);

    int lastestUpdateInDaysSinceEpoch = items
        .map((item) =>
            item.releaseDate.millisecondsSinceEpoch ~/
            millisecondsToDaysConversion)
        .reduce((curr, next) => curr > next ? curr : next);
    int nowInDaysSinceEpoch =
        DateTime.now().millisecondsSinceEpoch ~/ millisecondsToDaysConversion;
    int daysSinceLastUpdate =
        nowInDaysSinceEpoch - lastestUpdateInDaysSinceEpoch;
    listItems.add(
      genericItemDescription('{0} days since last update'.replaceAll(
        // TODO translate
        '{0}',
        daysSinceLastUpdate.toString(),
      )),
    );
    listItems.add(emptySpace1x());

    DateTime anniversaryDate =
        DateTime.parse(DateTime.now().year.toString() + '-08-09');
    int anniversaryDaysSinceEpoch =
        anniversaryDate.millisecondsSinceEpoch ~/ millisecondsToDaysConversion;
    if (DateTime.now().millisecondsSinceEpoch >
        anniversaryDate.millisecondsSinceEpoch) {
      anniversaryDaysSinceEpoch =
          DateTime.parse((DateTime.now().year + 1).toString() + '-08-09')
                  .millisecondsSinceEpoch ~/
              millisecondsToDaysConversion;
    }
    int daysLeft = anniversaryDaysSinceEpoch -
        (DateTime.now().millisecondsSinceEpoch ~/ millisecondsToDaysConversion);
    listItems.add(
      genericItemDescription('{0} days until anniversary'.replaceAll(
        // TODO translate
        '{0}',
        (daysLeft).toString(),
      )),
    );
    listItems.add(emptySpace1x());

    List<int> daysSinceLastUpdateList = List.empty(growable: true);
    for (int updateIndex = 0; updateIndex < items.length; updateIndex++) {
      MajorUpdateItem update = items[updateIndex];
      int updateDaysSinceEpoch = update.releaseDate.millisecondsSinceEpoch ~/
          millisecondsToDaysConversion;

      int previousUpdateDaysSinceEpoch = 0;

      bool hasPrevious = (updateIndex + 1) < items.length;
      if (!hasPrevious) continue;
      MajorUpdateItem previousUpdate = items[(updateIndex + 1)];
      previousUpdateDaysSinceEpoch =
          previousUpdate.releaseDate.millisecondsSinceEpoch ~/
              millisecondsToDaysConversion;

      daysSinceLastUpdateList
          .add((updateDaysSinceEpoch - previousUpdateDaysSinceEpoch));
    }

    double avgDaysPerUpdate = daysSinceLastUpdateList.reduce((a, b) => a + b) /
        daysSinceLastUpdateList.length;
    listItems.add(
      genericItemDescription(
        'Average days per update: {0}'.replaceAll(
          // TODO translate
          '{0}',
          avgDaysPerUpdate.toStringAsFixed(2),
        ),
      ),
    );
    int nextUpdateBasedOnAvgDaysSinceEpoch =
        (lastestUpdateInDaysSinceEpoch + avgDaysPerUpdate.round()) *
            millisecondsToDaysConversion;
    listItems.add(
      genericItemDescription(
        'Next update should be on {0} based on average days since update' // TODO translate
            .replaceAll(
          '{0}',
          simpleDate(
            DateTime.fromMillisecondsSinceEpoch(
              nextUpdateBasedOnAvgDaysSinceEpoch,
            ),
          ),
        ),
      ),
    );
    listItems.add(emptySpace1x());
    listItems.add(customDivider());
    listItems.add(emptySpace1x());

    List<int> lastXUpdatesList = [5, 10, 15];
    for (int lastXUpdate in lastXUpdatesList) {
      List<int> localDaysSinceLastUpdateList =
          daysSinceLastUpdateList.take(lastXUpdate).toList();
      listItems.add(
        genericItemDescription(
          // TODO translate
          'Next update should be on {0} based on average days since update (based on the last {1} updates)'
              .replaceAll(
                '{0}',
                simpleDate(
                  DateTime.fromMillisecondsSinceEpoch(
                    (lastestUpdateInDaysSinceEpoch +
                            (localDaysSinceLastUpdateList
                                        .reduce((a, b) => a + b) /
                                    localDaysSinceLastUpdateList.length)
                                .round()) *
                        millisecondsToDaysConversion,
                  ),
                ),
              )
              .replaceAll(
                '{1}',
                lastXUpdate.toString(),
              ),
        ),
      );
      listItems.add(emptySpace1x());
    }
    listItems.add(customDivider());
    listItems.add(emptySpace1x());

    List<TableRow> rows = [
      TableRow(children: [
        getTableHeading('Name'), // TODO translate
        getTableHeading('Date released'), // TODO translate
        getTableHeading('Days since previous update'), // TODO translate
      ])
    ];
    for (int updateIndex = 0; updateIndex < items.length; updateIndex++) {
      MajorUpdateItem update = items[updateIndex];
      int updateDaysSinceEpoch = update.releaseDate.millisecondsSinceEpoch ~/
          millisecondsToDaysConversion;

      int previousUpdateDaysSinceEpoch = 0;

      bool hasPrevious = (updateIndex + 1) < items.length;
      if (hasPrevious) {
        MajorUpdateItem previousUpdate = items[(updateIndex + 1)];
        previousUpdateDaysSinceEpoch =
            previousUpdate.releaseDate.millisecondsSinceEpoch ~/
                millisecondsToDaysConversion;
      }

      rows.add(
        TableRow(children: [
          getTableRow(update.title),
          getTableRow(simpleDate(update.releaseDate)),
          hasPrevious
              ? getTableRow(
                  (updateDaysSinceEpoch - previousUpdateDaysSinceEpoch)
                      .toString())
              : getTableRow('-'),
        ]),
      );
    }
    listItems.add(Table(children: rows));

    listItems.add(emptySpace1x());
    listItems.add(customDivider());
    listItems.add(emptySpace1x());

    return listWithScrollbar(
      shrinkWrap: true,
      itemCount: listItems.length,
      itemBuilder: (BuildContext context, int index) => listItems[index],
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 64),
    );
  }

  Widget getTableHeading(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20),
    );
  }

  Widget getTableRow(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }
}
