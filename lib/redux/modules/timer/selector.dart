import '../../../contracts/redux/app_state.dart';
import '../../../contracts/timer/timerItem.dart';

List<TimerItem> getTimers(AppState state) => state.timerState.timers;
