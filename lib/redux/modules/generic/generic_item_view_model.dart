import 'package:redux/redux.dart';

import '../../../contracts/redux/app_state.dart';
import '../setting/selector.dart';

class GenericItemViewModel {
  final bool genericTileIsCompact;
  final bool displayGenericItemColour;

  GenericItemViewModel({
    required this.genericTileIsCompact,
    required this.displayGenericItemColour,
  });

  static GenericItemViewModel fromStore(Store<AppState> store) {
    return GenericItemViewModel(
      genericTileIsCompact: getGenericTileIsCompact(store.state),
      displayGenericItemColour: getDisplayGenericItemColour(store.state),
    );
  }
}
