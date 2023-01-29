import '../../../contracts/redux/appState.dart';
import '../../../contracts/timer/timerItem.dart';

List<TimerItem> getTimers(AppState state) => state.timerState.timers;
