import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/youtubers_tile_presenter.dart';
import '../../contracts/data/major_update_item.dart';

const millisecondsToDaysConversion = 86400000;

class MajorUpdatesSpeculationPage extends StatelessWidget {
  final List<MajorUpdateItem> items;
  const MajorUpdatesSpeculationPage({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.speculation),
      body: getBody(context, items),
    );
  }

  Widget getBody(
    BuildContext bodyCtx,
    List<MajorUpdateItem> localMajorItems,
  ) {
    List<Widget> listItems = List.empty(growable: true);

    int latestUpdateInDaysSinceEpoch = items
        .map((item) =>
            item.releaseDate.millisecondsSinceEpoch ~/
            millisecondsToDaysConversion)
        .reduce((curr, next) => curr > next ? curr : next);
    int nowInDaysSinceEpoch =
        DateTime.now().millisecondsSinceEpoch ~/ millisecondsToDaysConversion;
    int daysSinceLastUpdate =
        nowInDaysSinceEpoch - latestUpdateInDaysSinceEpoch;
    listItems.add(
      GenericItemDescription(
        getTranslations().fromKey(LocaleKey.daysSinceLastUpdate).replaceAll(
              '{0}',
              daysSinceLastUpdate.toString(),
            ),
      ),
    );
    listItems.add(const EmptySpace1x());

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
      GenericItemDescription(
        getTranslations().fromKey(LocaleKey.daysUntilAnniversary).replaceAll(
              '{0}',
              (daysLeft).toString(),
            ),
      ),
    );
    listItems.add(const EmptySpace1x());

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
      GenericItemDescription(
        getTranslations().fromKey(LocaleKey.daysPerUpdate).replaceAll(
              '{0}',
              avgDaysPerUpdate.toStringAsFixed(2),
            ),
      ),
    );
    int nextUpdateBasedOnAvgDaysSinceEpoch =
        (latestUpdateInDaysSinceEpoch + avgDaysPerUpdate.round()) *
            millisecondsToDaysConversion;
    listItems.add(
      GenericItemDescription(
        getTranslations()
            .fromKey(LocaleKey.updateCouldBeOnDateBasedOnAverageDays)
            .replaceAll(
              '{0}',
              simpleDate(
                DateTime.fromMillisecondsSinceEpoch(
                  nextUpdateBasedOnAvgDaysSinceEpoch,
                ),
              ),
            )
            .replaceAll('{1}', ''),
      ),
    );
    listItems.add(const EmptySpace1x());
    listItems.add(getBaseWidget().customDivider());
    listItems.add(const EmptySpace1x());

    List<int> lastXUpdatesList = [5, 10, 15];
    for (int lastXUpdate in lastXUpdatesList) {
      List<int> localDaysSinceLastUpdateList =
          daysSinceLastUpdateList.take(lastXUpdate).toList();
      String dayString = simpleDate(
        DateTime.fromMillisecondsSinceEpoch(
          (latestUpdateInDaysSinceEpoch +
                  (localDaysSinceLastUpdateList.reduce((a, b) => a + b) /
                          localDaysSinceLastUpdateList.length)
                      .round()) *
              millisecondsToDaysConversion,
        ),
      );
      String extraInfo = getTranslations()
          .fromKey(LocaleKey.basedOnTheLastXUpdates)
          .replaceAll(
            '{0}',
            lastXUpdate.toString(),
          );
      listItems.add(
        GenericItemDescription(
          getTranslations()
              .fromKey(LocaleKey.updateCouldBeOnDateBasedOnAverageDays)
              .replaceAll('{0}', dayString)
              .replaceAll('{1}', '\n($extraInfo)'),
        ),
      );
      listItems.add(const EmptySpace1x());
    }
    listItems.add(getBaseWidget().customDivider());
    listItems.add(const EmptySpace1x());

    listItems.add(Card(child: podcast1616PlaylistTile(bodyCtx)));

    listItems.add(const EmptySpace1x());

    List<TableRow> rows = [
      TableRow(children: [
        getTableHeading(
          getTranslations().fromKey(LocaleKey.updateName),
        ),
        getTableHeading(
          getTranslations().fromKey(LocaleKey.updateDateReleased),
        ),
        getTableHeading(
          getTranslations().fromKey(LocaleKey.updateDaysSincePreviousUpdate),
        ),
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
          getUpdateNameTableRow(update.title, update.updateType),
          getUpdateNameTableRow(
              simpleDate(update.releaseDate), update.updateType),
          hasPrevious
              ? getUpdateNameTableRow(
                  (updateDaysSinceEpoch - previousUpdateDaysSinceEpoch)
                      .toString(),
                  update.updateType)
              : getUpdateNameTableRow('-', update.updateType),
        ]),
      );
    }
    listItems.add(Table(children: rows));

    listItems.add(const EmptySpace1x());
    listItems.add(getBaseWidget().customDivider());
    listItems.add(const EmptySpace1x());

    return listWithScrollbar(
      shrinkWrap: true,
      itemCount: listItems.length,
      itemBuilder: (BuildContext context, int index) => listItems[index],
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 64),
      scrollController: ScrollController(),
    );
  }

  Widget getTableHeading(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20),
    );
  }

  Widget getTableRow(String text, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor),
      ),
    );
  }

  Widget getUpdateNameTableRow(String text, UpdateType updateType) {
    Color? textColor;
    if (updateType == UpdateType.major) {
      textColor = Colors.lightBlue;
    }
    // if (updateType == UpdateType.minor) {
    //   textColor = Colors.red;
    // }
    if (updateType == UpdateType.expedition) {
      textColor = HexColor('D4BC38');
    }

    return getTableRow(text, textColor: textColor);
  }
}
