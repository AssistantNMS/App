import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/dialogs/baseDialog.dart';
import '../../components/responsiveGridView.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/timerTilePresenter.dart';
import '../../constants/UserSelectionIcons.dart';
import '../../contracts/timer/timerItem.dart';
import '../../helpers/actionHelper.dart';
import '../../helpers/genericHelper.dart';

const int millisecondsDrift = 1 * 60 * 1000; // 1 minute in milliseconds

class AddEditTimerPage extends StatefulWidget {
  final bool isEdit;
  final TimerItem timer;
  AddEditTimerPage(this.timer, this.isEdit);

  @override
  _AddEditTimerState createState() => _AddEditTimerState(timer, isEdit);
}

class _AddEditTimerState extends State<AddEditTimerPage> {
  String validationMessage;
  int selectedImageIndex = 0;
  bool isEdit;
  TimerItem timer;
  DateTime now = DateTime.now();

  _AddEditTimerState(this.timer, this.isEdit) {
    var selectedIndex = UserSelectionIcons.timer.indexOf(timer.icon);
    this.selectedImageIndex = selectedIndex >= 0 ? selectedIndex : 0;
    this.timer.icon = UserSelectionIcons.timer[this.selectedImageIndex];

    if (this.timer.startDate != null &&
        (now.millisecondsSinceEpoch -
                    this.timer.startDate.millisecondsSinceEpoch)
                .abs() <
            millisecondsDrift) {
      // If startDate is set to now-ish
      this.timer.startDate = now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: timer.name ?? getTranslations().fromKey(LocaleKey.newTimer),
      actions: [
        editNameInAppBarAction(
          context,
          LocaleKey.name,
          nameIfEmpty: LocaleKey.newTimer,
          currentName: this.timer.name,
          onEdit: (String newName) => setState(() {
            this.timer.name = newName;
          }),
        )
      ],
      body: getBody(context),
      fab: FloatingActionButton(
        onPressed: () {
          if (timer.startDate.millisecondsSinceEpoch >
              timer.completionDate.millisecondsSinceEpoch) {
            simpleDialog(
              context,
              getTranslations().fromKey(LocaleKey.error),
              getTranslations()
                  .fromKey(LocaleKey.errorStartDateShouldNotBeAfterEndDate),
              buttons: [simpleDialogCloseButton(context)],
            );
            return;
          }
          Navigator.pop(
            context,
            TimerItem(
              name: timer.name ?? getTranslations().fromKey(LocaleKey.newTimer),
              uuid: this.timer.uuid,
              icon: this.timer.icon,
              startDate: this.timer.startDate,
              completionDate: this.timer.completionDate,
            ),
          );
        },
        heroTag: 'AddEditTimerPage',
        child: Icon(Icons.check),
        foregroundColor: getTheme().fabForegroundColourSelector(context),
        backgroundColor: getTheme().fabColourSelector(context),
      ),
    );
  }

  Widget getBody(BuildContext context) {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(Card(
      child: timerDateTimeTilePresenter(
        context,
        LocaleKey.startDate,
        timer.startDate ?? now,
        (DateTime newDate) => this.setState(() {
          timer.startDate = newDate;
        }),
        minDate: now.subtract(Duration(days: 365)),
        maxDate: now,
        showEditIcon: (timer.startDate == now),
        trailing: IconButton(
            icon: Icon(Icons.today),
            onPressed: () => this.setState(() {
                  timer.startDate = now;
                })),
      ),
    ));
    widgets.add(Card(
      child: timerDateTimeTilePresenter(
        context,
        LocaleKey.endDate,
        timer.completionDate ?? now,
        (DateTime newDate) => this.setState(() {
          timer.completionDate = newDate;
        }),
        minDate: now,
        maxDate: now.add(Duration(days: 365)),
        showEditIcon: true,
      ),
    ));

    widgets.add(Wrap(
      alignment: WrapAlignment.center,
      children: getQuickAccessButtons(context),
    ));

    widgets.add(responsiveSelectorGrid(
      context,
      UserSelectionIcons.timer,
      selectedImageIndex,
      (BuildContext innerContext, String icon) =>
          gridIconTilePresenter(innerContext, '', icon, (String icon) {
        var selectedIndex = UserSelectionIcons.timer.indexOf(icon);
        this.setState(() {
          timer.icon = icon;
          selectedImageIndex = selectedIndex;
        });
      }),
    ));

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  void setEndDateQuickSelect(Duration dur) => this.setState(() {
        timer.completionDate = timer.startDate.add(dur);
      });

  List<Widget> getQuickAccessButtons(BuildContext context) {
    return [
      genericChip(
        context,
        getTranslations().fromKey(LocaleKey.hour).replaceAll('{0}', '1'),
        onTap: () => setEndDateQuickSelect(Duration(hours: 1)),
      ),
      genericChip(
        context,
        getTranslations().fromKey(LocaleKey.hours).replaceAll('{0}', '2'),
        onTap: () => setEndDateQuickSelect(Duration(hours: 2)),
      ),
      genericChip(
        context,
        getTranslations().fromKey(LocaleKey.hours).replaceAll('{0}', '5'),
        onTap: () => setEndDateQuickSelect(Duration(hours: 5)),
      ),
      genericChip(
        context,
        getTranslations().fromKey(LocaleKey.hours).replaceAll('{0}', '10'),
        onTap: () => setEndDateQuickSelect(Duration(hours: 10)),
      ),
      genericChip(
        context,
        getTranslations().fromKey(LocaleKey.day).replaceAll('{0}', '1'),
        onTap: () => setEndDateQuickSelect(Duration(days: 1)),
      ),
      genericChip(
        context,
        getTranslations().fromKey(LocaleKey.days).replaceAll('{0}', '2'),
        onTap: () => setEndDateQuickSelect(Duration(days: 2)),
      ),
    ];
  }
}
