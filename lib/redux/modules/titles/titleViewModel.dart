import '../setting/actions.dart';
import 'package:redux/redux.dart';

import '../../../contracts/redux/appState.dart';
import '../setting/selector.dart';
import 'actions.dart';
import 'selector.dart';

class TitleViewModel {
  String? playerTitle;
  List<String> owned;
  bool hideCompleted;

  Function(String itemId) addToOwned;
  Function(String id) removeFromOwned;
  Function() removeAll;
  Function(String newName) setPlayerName;
  Function(bool hideCompleted) setHideCompleted;

  TitleViewModel({
    required this.playerTitle,
    required this.owned,
    required this.hideCompleted,
    required this.addToOwned,
    required this.removeFromOwned,
    required this.removeAll,
    required this.setPlayerName,
    required this.setHideCompleted,
  });

  static TitleViewModel fromStore(Store<AppState> store) {
    return TitleViewModel(
      playerTitle: getPlayerName(store.state),
      owned: getOwned(store.state),
      hideCompleted: getHideCompleted(store.state),
      addToOwned: (String itemId) => store.dispatch(AddTitleAction(itemId)),
      removeFromOwned: (String itemId) =>
          store.dispatch(RemoveTitleAction(itemId)),
      removeAll: () => store.dispatch(RemoveAllTitlesAction()),
      setPlayerName: (String newName) => store.dispatch(SetPlayerName(newName)),
      setHideCompleted: (bool hideCompleted) =>
          store.dispatch(SetHideCompletedAction(hideCompleted)),
    );
  }
}
