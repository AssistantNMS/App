import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

bool isInFestivePeriod() => //
    // true ||
    isValentinesPeriod() || //
    isChristmasPeriod();

double numDayDiff(DateTime startDate, DateTime endDate) {
  int diff = endDate.millisecondsSinceEpoch - startDate.millisecondsSinceEpoch;
  var seconds = diff / 1000;
  var minutes = seconds / 60;
  var hours = minutes / 60;
  var days = hours / 24;
  return days;
}
