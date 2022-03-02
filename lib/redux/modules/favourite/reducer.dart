import 'package:redux/redux.dart';

import '../../../contracts/redux/favouriteState.dart';
import '../../../contracts/favourite/favouriteItem.dart';
import 'actions.dart';

final favouriteReducer = combineReducers<FavouriteState>([
  TypedReducer<FavouriteState, AddFavouriteAction>(_addFavourite),
  TypedReducer<FavouriteState, RemoveFavouriteAction>(_removeFavourite),
]);

FavouriteState _addFavourite(FavouriteState state, AddFavouriteAction action) {
  List<FavouriteItem> newList =
      state.favouriteItems ?? List.empty(growable: true);
  newList.add(action.newItem);
  return state.copyWith(favouriteItems: newList);
}

FavouriteState _removeFavourite(
    FavouriteState state, RemoveFavouriteAction action) {
  var items = state.favouriteItems ?? List.empty(growable: true);
  List<FavouriteItem> newList = List.empty(growable: true);
  for (var fav in items) {
    if (fav.id == action.itemId) continue;
    newList.add(fav);
  }
  return state.copyWith(favouriteItems: newList);
}
