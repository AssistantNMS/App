import '../data/quicksilver_store.dart';
import '../required_item_details.dart';

class QuicksilverStoreDetails {
  QuicksilverStore store;
  List<RequiredItemDetails> itemsRequired;
  List<RequiredItemDetails> items;

  QuicksilverStoreDetails({
    required this.store,
    required this.items,
    required this.itemsRequired,
  });

  factory QuicksilverStoreDetails.initial() => QuicksilverStoreDetails(
        store: QuicksilverStore.fromRawJson('{}'),
        items: List.empty(),
        itemsRequired: List.empty(),
      );
}
