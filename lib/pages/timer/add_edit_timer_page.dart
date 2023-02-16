// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/responsive_grid_view.dart';
import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/timer_tile_presenter.dart';
import '../../constants/user_selection_icons.dart';
import '../../contracts/timer/timer_item.dart';
import '../../helpers/action_helper.dart';
import '../../helpers/generic_helper.dart';

const int millisecondsDrift = 1 * 60 * 1000; // 1 minute in milliseconds

class AddEditTimerPage extends StatefulWidget {
  final bool isEdit;
  final TimerItem timer;
  const AddEditTimerPage(this.timer, this.isEdit, {Key? key}) : super(key: key);

  @override
  _AddEditTimerState createState() => _AddEditTimerState(timer, isEdit);
}

class _AddEditTimerState extends State<AddEditTimerPage> {
  String? validationMessage;
  int selectedImageIndex = 0;
  bool isEdit;
  TimerItem timer;
  DateTime now = DateTime.now();

  _AddEditTimerState(this.timer, this.isEdit) {
    int selectedIndex = UserSelectionIcons.timer.indexOf(timer.icon ?? '');
    selectedImageIndex = selectedIndex >= 0 ? selectedIndex : 0;
    timer.icon = UserSelectionIcons.timer[selectedImageIndex];

    int diff =
        now.millisecondsSinceEpoch - timer.startDate.millisecondsSinceEpoch;
    if (diff.abs() < millisecondsDrift) {
      // If startDate is set to now-ish
      timer.startDate = now;
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
          currentName: timer.name ?? '...',
          onEdit: (String newName) => setState(() {
            timer.name = newName;
          }),
        )
      ],
      body: getBody(context),
      fab: FloatingActionButton(
        onPressed: () {
          if (timer.startDate.millisecondsSinceEpoch >
              timer.completionDate.millisecondsSinceEpoch) {
            getDialog().showSimpleDialog(
              context,
              getTranslations().fromKey(LocaleKey.error),
              Text(
                getTranslations()
                    .fromKey(LocaleKey.errorStartDateShouldNotBeAfterEndDate),
              ),
              buttonBuilder: (BuildContext ctx) => [
                getDialog().simpleDialogCloseButton(ctx),
              ],
            );
            return;
          }
          getNavigation().pop(
            context,
            TimerItem(
              name: timer.name ?? getTranslations().fromKey(LocaleKey.newTimer),
              uuid: timer.uuid,
              icon: timer.icon,
              startDate: timer.startDate,
              completionDate: timer.completionDate,
            ),
          );
        },
        heroTag: 'AddEditTimerPage',
        child: const Icon(Icons.check),
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
        timer.startDate,
        (DateTime newDate) => setState(() {
          timer.startDate = newDate;
        }),
        minDate: now.subtract(const Duration(days: 365)),
        maxDate: now,
        showEditIcon: (timer.startDate == now),
        trailing: IconButton(
            icon: const Icon(Icons.today),
            onPressed: () => setState(() {
                  timer.startDate = now;
                })),
      ),
    ));
    widgets.add(Card(
      child: timerDateTimeTilePresenter(
        context,
        LocaleKey.endDate,
        timer.completionDate,
        (DateTime newDate) => setState(() {
          timer.completionDate = newDate;
        }),
        minDate: now,
        maxDate: now.add(const Duration(days: 365)),
        showEditIcon: true,
      ),
    ));

    widgets.add(Wrap(
      spacing: 4,
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
        setState(() {
          timer.icon = icon;
          selectedImageIndex = selectedIndex;
        });
      }),
    ));

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
      scrollController: ScrollController(),
    );
  }

  void setEndDateQuickSelect(Duration dur) => setState(() {
        timer.completionDate = timer.startDate.add(dur);
      });

  List<Widget> getQuickAccessButtons(BuildContext context) {
    return [
      getBaseWidget().appChip(
        text: getTranslations().fromKey(LocaleKey.hour).replaceAll('{0}', '1'),
        onTap: () => setEndDateQuickSelect(const Duration(hours: 1)),
      ),
      getBaseWidget().appChip(
        text: getTranslations().fromKey(LocaleKey.hours).replaceAll('{0}', '2'),
        onTap: () => setEndDateQuickSelect(const Duration(hours: 2)),
      ),
      getBaseWidget().appChip(
        text: getTranslations().fromKey(LocaleKey.hours).replaceAll('{0}', '5'),
        onTap: () => setEndDateQuickSelect(const Duration(hours: 5)),
      ),
      getBaseWidget().appChip(
        text:
            getTranslations().fromKey(LocaleKey.hours).replaceAll('{0}', '10'),
        onTap: () => setEndDateQuickSelect(const Duration(hours: 10)),
      ),
      getBaseWidget().appChip(
        text: getTranslations().fromKey(LocaleKey.day).replaceAll('{0}', '1'),
        onTap: () => setEndDateQuickSelect(const Duration(days: 1)),
      ),
      getBaseWidget().appChip(
        text: getTranslations().fromKey(LocaleKey.days).replaceAll('{0}', '2'),
        onTap: () => setEndDateQuickSelect(const Duration(days: 2)),
      ),
    ];
  }
}
