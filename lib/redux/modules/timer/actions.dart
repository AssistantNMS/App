import '../../../contracts/timer/timer_item.dart';
import '../base/persist_to_storage.dart';

class AddTimerAction extends PersistToStorage {
  final TimerItem timerItem;
  AddTimerAction(this.timerItem);
}

class EditTimerAction extends PersistToStorage {
  final TimerItem timerItem;
  EditTimerAction(this.timerItem);
}

class RemoveTimerAction extends PersistToStorage {
  final String timerId;
  RemoveTimerAction(this.timerId);
}
