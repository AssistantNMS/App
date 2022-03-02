import './requiredItem.dart';
import 'genericPageItem.dart';

class GenericPageAllRequired {
  String typeName;
  String id;
  String name;
  GenericPageItem genericItem;
  List<RequiredItem> requiredItems;

  GenericPageAllRequired(
      {this.typeName,
      this.id,
      this.name,
      this.genericItem,
      this.requiredItems});

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
