import 'dart:math';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class TimerItem {
  int notificationId;
  String uuid;
  String name;
  String icon;
  DateTime startDate;
  DateTime completionDate;

  TimerItem(
      {this.name,
      this.icon,
      uuid,
      notificationId,
      this.startDate,
      this.completionDate}) {
    this.uuid = uuid ?? getNewGuid();
    this.notificationId = notificationId ?? Random().nextInt(10000);
  }

  factory TimerItem.addOrEditDefault(context) => TimerItem(
        startDate: DateTime.now(),
        completionDate: DateTime.now(),
        name: getTranslations().fromKey(LocaleKey.newTimer),
      );

  TimerItem copyWith({
    int notificationId,
    String uuid,
    String name,
    String icon,
    DateTime startDate,
    DateTime completionDate,
  }) {
    return TimerItem(
      notificationId: notificationId ?? this.notificationId,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      startDate: startDate ?? this.startDate,
      completionDate: completionDate ?? this.completionDate,
    );
  }

  factory TimerItem.fromJson(Map<String, dynamic> json) => TimerItem(
        notificationId: readIntSafe(json, 'notificationId'),
        uuid: readStringSafe(json, 'uuid'),
        name: readStringSafe(json, 'name'),
        icon: readStringSafe(json, 'icon'),
        startDate: readDateSafe(json, 'startDate'),
        completionDate: readDateSafe(json, 'completionDate'),
      );

  Map<String, dynamic> toJson() => {
        'notificationId': notificationId,
        'uuid': uuid,
        'name': name,
        'icon': icon,
        'startDate': startDate.toString(),
        'completionDate': completionDate.toString(),
      };
}
