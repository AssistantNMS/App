import '../../../contracts/favourite/favourite_item.dart';
import '../base/persistToStorage.dart';

class AddFavouriteAction extends PersistToStorage {
  final FavouriteItem newItem;
  AddFavouriteAction(this.newItem);
}

class RemoveFavouriteAction extends PersistToStorage {
  final String itemId;
  RemoveFavouriteAction(this.itemId);
}
