import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:meta/meta.dart';

import '../timer/timerItem.dart';

@immutable
class TimerState {
  final List<TimerItem> timers;

  const TimerState({
    this.timers,
  });

  factory TimerState.initial() {
    return TimerState(timers: List.empty(growable: true));
  }

  TimerState copyWith({
    List<TimerItem> timers,
  }) {
    return TimerState(timers: timers ?? this.timers);
  }

  factory TimerState.fromJson(Map<String, dynamic> json) {
    if (json == null) return TimerState.initial();
    try {
      return TimerState(
        timers: readListSafe<TimerItem>(
          json,
          'timers',
          (p) => TimerItem.fromJson(p),
        ).toList(),
      );
    } catch (exception) {
      return TimerState.initial();
    }
  }

  Map<String, dynamic> toJson() {
    return {'timers': timers};
  }
}
