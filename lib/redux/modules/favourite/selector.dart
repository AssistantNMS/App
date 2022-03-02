import '../../../contracts/redux/favouriteState.dart';

import '../../../contracts/redux/appState.dart';
import '../../../contracts/favourite/favouriteItem.dart';

List<FavouriteItem> getFavourites(AppState state) =>
    state.favouriteState?.favouriteItems ??
    FavouriteState.initial().favouriteItems;
