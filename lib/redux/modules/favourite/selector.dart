import '../../../contracts/favourite/favouriteItem.dart';
import '../../../contracts/redux/appState.dart';

List<FavouriteItem> getFavourites(AppState state) =>
    state.favouriteState.favouriteItems;
