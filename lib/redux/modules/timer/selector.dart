import '../../../contracts/redux/app_state.dart';
import '../../../contracts/timer/timer_item.dart';

List<TimerItem> getTimers(AppState state) => state.timerState.timers;
