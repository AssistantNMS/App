import '../../contracts/genericPageItem.dart';

String gameItemIconHero(GenericPageItem genericItem) {
  if (genericItem == null || genericItem.id == null) return null;
  return '${genericItem.id}-item-icon';
}

String gameItemNameHero(GenericPageItem genericItem) {
  if (genericItem == null ||
      genericItem.id == null ||
      genericItem.name == null) {
    return null;
  }
  return '${genericItem.id}-item-name-${genericItem.name}';
}

String gameItemBackgroundHero(GenericPageItem genericItem) {
  if (genericItem == null ||
      genericItem.id == null ||
      genericItem.colour == null) return null;
  return '${genericItem.id}-item-colour-${genericItem.colour}';
}
