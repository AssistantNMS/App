import '../../../contracts/favourite/favourite_item.dart';
import '../../../contracts/redux/appState.dart';

List<FavouriteItem> getFavourites(AppState state) =>
    state.favouriteState.favouriteItems;
