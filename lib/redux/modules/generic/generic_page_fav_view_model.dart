import 'package:redux/redux.dart';

import '../../../contracts/favourite/favourite_item.dart';
import '../../../contracts/redux/app_state.dart';
import '../favourite/actions.dart';
import '../favourite/selector.dart';
import '../setting/selector.dart';

class GenericPageFavViewModel {
  final bool displayGenericItemColour;
  final List<FavouriteItem> favourites;

  Function(String itemId) removeFavourite;
  Function(FavouriteItem newItem) addFavourite;

  GenericPageFavViewModel({
    required this.displayGenericItemColour,
    required this.favourites,
    //
    required this.addFavourite,
    required this.removeFavourite,
  });

  static GenericPageFavViewModel fromStore(Store<AppState> store) {
    return GenericPageFavViewModel(
      displayGenericItemColour: getDisplayGenericItemColour(store.state),
      favourites: getFavourites(store.state),
      //
      addFavourite: (FavouriteItem newItem) =>
          store.dispatch(AddFavouriteAction(newItem)),
      removeFavourite: (String itemId) =>
          store.dispatch(RemoveFavouriteAction(itemId)),
    );
  }
}
