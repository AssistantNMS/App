import '../../../contracts/timer/timer_item.dart';
import 'package:redux/redux.dart';

import '../../../contracts/redux/timer_state.dart';
import 'actions.dart';

final timerReducer = combineReducers<TimerState>([
  TypedReducer<TimerState, AddTimerAction>(_addTimerAction),
  TypedReducer<TimerState, EditTimerAction>(_editTimerAction),
  TypedReducer<TimerState, RemoveTimerAction>(_removeTimerAction),
]);

TimerState _addTimerAction(TimerState state, AddTimerAction action) {
  List<TimerItem> timers = state.timers;
  timers.add(action.timerItem);
  return state.copyWith(timers: timers);
}

TimerState _editTimerAction(TimerState state, EditTimerAction action) {
  List<TimerItem> newItems = List.empty(growable: true);
  for (int inventoryIndex = 0;
      inventoryIndex < state.timers.length;
      inventoryIndex++) {
    TimerItem temp = state.timers[inventoryIndex];
    if (state.timers[inventoryIndex].uuid == action.timerItem.uuid) {
      temp = temp.copyWith(
        uuid: action.timerItem.uuid,
        name: action.timerItem.name,
        icon: action.timerItem.icon,
        completionDate: action.timerItem.completionDate,
      );
    }
    newItems.add(temp);
  }
  return state.copyWith(timers: newItems);
}

TimerState _removeTimerAction(TimerState state, RemoveTimerAction action) {
  List<TimerItem> newItems = List.empty(growable: true);
  for (int inventoryIndex = 0;
      inventoryIndex < state.timers.length;
      inventoryIndex++) {
    TimerItem temp = state.timers[inventoryIndex];
    if (state.timers[inventoryIndex].uuid == action.timerId) continue;
    newItems.add(temp);
  }
  return state.copyWith(timers: newItems);
}
