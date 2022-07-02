import '../base/persistToStorage.dart';

class AddTitleAction extends PersistToStorage {
  final String itemId;
  AddTitleAction(this.itemId);
}

class RemoveTitleAction extends PersistToStorage {
  final String itemId;
  RemoveTitleAction(this.itemId);
}

class RemoveAllTitlesAction extends PersistToStorage {
  RemoveAllTitlesAction();
}

class SetHideCompletedAction extends PersistToStorage {
  final bool hideCompleted;
  SetHideCompletedAction(this.hideCompleted);
}
