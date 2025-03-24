import '../contracts/alienPuzzle/alien_puzzle.dart';
import '../contracts/enum/currency_type.dart';
import '../contracts/generated/community_link_view_model.dart';
import '../contracts/generic_page_item.dart';
import '../contracts/guide/guide.dart';
import '../contracts/helloGames/news_item.dart';
import '../contracts/helloGames/release_note.dart';
import '../contracts/inventory/inventory_slot_with_generic_page_item.dart';
import '../contracts/nmsfm/nmsfm_track_data.dart';
import '../contracts/portal/portal_record.dart';
import '../contracts/required_item_details.dart';
import '../contracts/seasonalExpedition/seasonal_expedition_phase.dart';
import '../contracts/title_data_with_owned.dart';

bool search(GenericPageItem item, String searchText) =>
    searchGenericPageItem(item, searchText);

bool searchRawMaterial(GenericPageItem rawMaterial, String searchText) =>
    (rawMaterial.name.toLowerCase().contains(searchText));

bool searchGenericPageItem(GenericPageItem genericItem, String searchText) =>
    (genericItem.name.toLowerCase().contains(searchText));
// (genericItem.name.toLowerCase().contains(searchText) ||
//     genericItem.group.toLowerCase().contains(searchText));

bool searchPortal(PortalRecord option, String search) {
  if ((option.name ?? '').toLowerCase().contains(search)) return true;
  if (option.tags.isEmpty) return false;

  if (option.tags.any((tag) => tag.toLowerCase().contains(search))) {
    return true;
  }
  return false;
}

bool searchGuide(NmsGuide guide, String text) {
  // if (guide.author.contains(text)) return true;
  if (guide.title.contains(text)) return true;
  // if (guide.sections.any((sec) => sec.heading.contains(text))) return true;
  // if (guide.sections
  //     .any((sec) => sec.items.any((item) => item.content.contains(text))))
  //   return true;
  if (guide.tags.any((tag) => tag.contains(text))) return true;

  return false;
}

bool searchReleaseNotes(ReleaseNote option, String search) =>
    option.name.toLowerCase().contains(search) ||
    option.description.toLowerCase().contains(search) ||
    (option.isPc && search.toLowerCase().contains('pc')) ||
    (option.isPs4 && search.toLowerCase().contains('ps')) ||
    (option.isXb1 && search.toLowerCase().contains('xb'));

bool searchNews(NewsItem option, String search) =>
    option.name.toLowerCase().contains(search) ||
    option.description.toLowerCase().contains(search);

bool searchCommunityLinksByName(CommunityLinkViewModel option, String search) =>
    option.name.toLowerCase().contains(search);

bool searchGroup(GenericPageItem item, String searchText) =>
    (item.group).toLowerCase().contains(searchText);
bool searchType(GenericPageItem item, String searchText) =>
    (item.typeName).toLowerCase().contains(searchText);

// TODO search by rarity
bool searchRarity(GenericPageItem item, String searchText) =>
    search(item, searchText);
// (item is RawMaterial) ? item.rarity == rarityValues.map[searchText] : false;

bool searchMinCredit(GenericPageItem item, int min) =>
    item.currencyType == CurrencyType.CREDITS && item.baseValueUnits > min;
bool searchMaxCredit(GenericPageItem item, int max) =>
    item.currencyType == CurrencyType.CREDITS && item.baseValueUnits < max;

bool searchInventory(InventorySlotWithGenericPageItem option, String search) =>
    option.name.toLowerCase().contains(search);

bool searchFavourite(RequiredItemDetails req, String searchText) =>
    req.name.toLowerCase().contains(searchText);

bool searchTitle(TitleDataWithOwned titleData, String search) {
  if (titleData.title.toLowerCase().contains(search) ||
      titleData.description.toLowerCase().contains(search)) {
    return true;
  }
  return false;
}

bool searchNmsfm(NmsfmTrackData track, String search) {
  if ((track.title ?? '').toLowerCase().contains(search) ||
      (track.artist ?? '').toLowerCase().contains(search)) {
    return true;
  }
  return false;
}

bool searchAlienPuzzleIncomingMessages(AlienPuzzle alienPuzzle, String search) {
  if (alienPuzzle.incomingMessages
      .any((msg) => msg.toLowerCase().contains(search))) {
    return true;
  }
  List<String> optionTexts = List.empty(growable: true);
  for (Option option in alienPuzzle.options) {
    optionTexts.add(option.name);
    optionTexts.add(option.text);
  }
  if (optionTexts.any((opt) => opt.toLowerCase().contains(search))) return true;
  return false;
}

bool searchSeasonalExpeditionPhase(
    SeasonalExpeditionPhase seasonalExpedition, String search) {
  // if (seasonalExpedition.title
  //     .any((msg) => msg.toLowerCase().contains(search))) return true;
  return false;
}
