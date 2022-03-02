import '../../../redux/modules/setting/actions.dart';
import 'package:redux/redux.dart';

import '../../../contracts/redux/appState.dart';
import '../setting/selector.dart';
import 'actions.dart';
import 'selector.dart';

class TitleViewModel {
  String playerTitle;
  List<String> owned;

  Function(String itemId) addToOwned;
  Function(String id) removeFromOwned;
  Function() removeAll;
  Function(String newName) setPlayerName;

  TitleViewModel({
    this.owned,
    this.addToOwned,
    this.removeFromOwned,
    this.removeAll,
    this.playerTitle,
    this.setPlayerName,
  });

  static TitleViewModel fromStore(Store<AppState> store) {
    return TitleViewModel(
      playerTitle: getPlayerName(store.state),
      owned: getOwned(store.state),
      addToOwned: (String itemId) => store.dispatch(AddTitleAction(itemId)),
      removeFromOwned: (String itemId) =>
          store.dispatch(RemoveTitleAction(itemId)),
      removeAll: () => store.dispatch(RemoveAllTitlesAction()),
      setPlayerName: (String newName) => store.dispatch(SetPlayerName(newName)),
    );
  }
}
