import '../../../contracts/favourite/favourite_item.dart';
import '../../../contracts/redux/app_state.dart';

List<FavouriteItem> getFavourites(AppState state) =>
    state.favouriteState.favouriteItems;
