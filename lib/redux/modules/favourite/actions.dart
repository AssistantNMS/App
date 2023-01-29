import '../../../contracts/favourite/favourite_item.dart';
import '../base/persist_to_storage.dart';

class AddFavouriteAction extends PersistToStorage {
  final FavouriteItem newItem;
  AddFavouriteAction(this.newItem);
}

class RemoveFavouriteAction extends PersistToStorage {
  final String itemId;
  RemoveFavouriteAction(this.itemId);
}
