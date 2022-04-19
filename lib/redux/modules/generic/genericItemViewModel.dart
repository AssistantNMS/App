import 'package:redux/redux.dart';

import '../../../contracts/redux/appState.dart';
import '../setting/selector.dart';

class GenericItemViewModel {
  final bool genericTileIsCompact;
  final bool displayGenericItemColour;

  GenericItemViewModel({
    this.genericTileIsCompact,
    this.displayGenericItemColour,
  });

  static GenericItemViewModel fromStore(Store<AppState> store) {
    return GenericItemViewModel(
      genericTileIsCompact: getGenericTileIsCompact(store.state),
      displayGenericItemColour: getDisplayGenericItemColour(store.state),
    );
  }
}
