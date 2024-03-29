import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../contracts/timer/timer_item.dart';

Widget timerTilePresenter(
  BuildContext context,
  TimerItem timer,
  void Function(TimerItem) onEdit,
  void Function(String) onDelete,
) {
  DateTime tweakedStart = (DateTime(
    timer.startDate.year,
    timer.startDate.month,
    timer.startDate.day,
    timer.startDate.hour,
    timer.startDate.minute,
    timer.startDate.second,
    timer.startDate.millisecond,
  ));
  DateTime tweakedEnd = (DateTime(
    timer.completionDate.year,
    timer.completionDate.month,
    timer.completionDate.day,
    timer.completionDate.hour,
    timer.completionDate.minute,
    timer.completionDate.second,
    timer.completionDate.millisecond,
  ));

  return genericListTileWithSubtitle(
    context,
    leadingImage: timer.icon,
    name: timer.name ?? '...',
    subtitle: Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: getProgressbarFromDates(
        context,
        tweakedStart,
        tweakedEnd,
        animation: false,
      ),
    ),
    trailing: popupMenu(
      context,
      onEdit: () => onEdit(timer),
      onDelete: () => onDelete(timer.uuid),
    ),
    onTap: () => onEdit(timer),
  );
}

Widget timerDateTimeTilePresenter(
  BuildContext context,
  LocaleKey localeKey,
  DateTime currentDateTime,
  Function(DateTime) onDateSet, {
  required DateTime? minDate,
  required DateTime? maxDate,
  required bool showEditIcon,
  Widget? trailing,
}) {
  var now = DateTime.now();
  Future Function() onTap;
  onTap = () async {
    DateTime? dayOfTheYear = await showDatePicker(
      context: context,
      initialDate: currentDateTime,
      firstDate: minDate ?? now.subtract(const Duration(days: 365)),
      lastDate: maxDate ?? now.add(const Duration(days: 365)),
    );
    if (dayOfTheYear == null) return;

    TimeOfDay? timeOfDay = await showTimePicker(
      initialTime: TimeOfDay(
        hour: currentDateTime.hour,
        minute: currentDateTime.minute,
      ),
      context: context,
    );
    if (timeOfDay == null) return;

    var dateString = _getDateTimeString(dayOfTheYear, timeOfDay);
    var selectedDate = DateTime.tryParse(dateString);
    if (selectedDate == null) return;
    onDateSet(selectedDate);
  };

  return genericListTileWithSubtitle(
    context,
    leadingImage: null,
    name: getTranslations().fromKey(localeKey),
    subtitle: Text(
      DateFormat(UIConstants.dateTimeFormat).format(currentDateTime),
    ),
    trailing: showEditIcon
        ? IconButton(icon: const Icon(Icons.edit), onPressed: onTap)
        : trailing,
    onTap: onTap,
  );
}

String _getDateTimeString(DateTime dayOfTheYear, TimeOfDay timeOfDay) {
  String result = '${dayOfTheYear.year}-';
  result += padString(dayOfTheYear.month.toString(), 2);
  result += '-';
  result += padString(dayOfTheYear.day.toString(), 2);
  result += ' ';
  result += padString(timeOfDay.hour.toString(), 2);
  result += ':';
  result += padString(timeOfDay.minute.toString(), 2);
  result += ':00';
  return result;
}
