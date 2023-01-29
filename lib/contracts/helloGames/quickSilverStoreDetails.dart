import '../data/quicksilverStore.dart';
import '../requiredItemDetails.dart';

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
