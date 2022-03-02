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
        notificationId: (json["notificationId"] as int) ?? 0,
        uuid: json["uuid"],
        name: json["name"],
        icon: json["icon"],
        startDate: DateTime.tryParse(json["startDate"]),
        completionDate: DateTime.tryParse(json["completionDate"]),
      );

  Map<String, dynamic> toJson() => {
        'notificationId': this.notificationId,
        'uuid': this.uuid,
        'name': this.name,
        'icon': this.icon,
        'startDate': this.startDate.toString(),
        'completionDate': this.completionDate.toString(),
      };
}
