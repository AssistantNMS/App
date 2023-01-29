// ignore_for_file: unnecessary_null_comparison

import '../../contracts/generic_page_item.dart';

String? gameItemIconHero(GenericPageItem genericItem) {
  if (genericItem == null || genericItem.id == null) return null;
  return '${genericItem.id}-item-icon';
}

String? gameItemNameHero(GenericPageItem genericItem) {
  if (genericItem == null ||
      genericItem.id == null ||
      genericItem.name == null) {
    return null;
  }
  return '${genericItem.id}-item-name-${genericItem.name}';
}

String? gameItemBackgroundHero(GenericPageItem genericItem) {
  if (genericItem == null ||
      genericItem.id == null ||
      genericItem.colour == null) return null;
  return '${genericItem.id}-item-colour-${genericItem.colour}';
}
