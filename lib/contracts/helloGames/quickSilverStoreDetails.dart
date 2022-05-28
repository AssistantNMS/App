import '../data/quicksilverStore.dart';
import '../requiredItemDetails.dart';

class QuicksilverStoreDetails {
  QuicksilverStore store;
  List<RequiredItemDetails> itemsRequired;
  List<RequiredItemDetails> items;

  QuicksilverStoreDetails({
    this.store,
    this.items,
    this.itemsRequired,
  });
}
