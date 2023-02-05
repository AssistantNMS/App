import './required_item.dart';
import 'generic_page_item.dart';

class GenericPageAllRequired {
  String typeName;
  String id;
  String name;
  GenericPageItem genericItem;
  List<RequiredItem> requiredItems;

  GenericPageAllRequired({
    required this.typeName,
    required this.id,
    required this.name,
    required this.genericItem,
    required this.requiredItems,
  });

  static GenericPageAllRequired fromGenericItem(GenericPageItem item) {
    List<RequiredItem> temp = List.empty(growable: true);
    temp.add(RequiredItem(id: item.id, quantity: 1));
    return GenericPageAllRequired(
      typeName: item.typeName,
      id: item.id,
      name: item.name,
      genericItem: item,
      requiredItems: temp,
    );
  }
}
