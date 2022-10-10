import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../../constants/Fonts.dart';
import '../../../contracts/enum/homepageType.dart';
import '../../../contracts/redux/appState.dart';

String getSelectedLanguage(AppState state) =>
    state?.settingState?.selectedLanguage ?? 'en';

bool getGuidesIsCompact(AppState state) =>
    state?.settingState?.guidesIsCompact ?? false;

bool getGenericTileIsCompact(AppState state) =>
    state?.settingState?.genericTileIsCompact ?? false;

bool getShowMaterialTheme(AppState state) =>
    state?.settingState?.showMaterialTheme ?? false;

bool getDisplayGenericItemColour(AppState state) =>
    state?.settingState?.displayGenericItemColour ?? false;

bool getIsValentines2020IntroHidden(AppState state) =>
    state?.settingState?.isValentines2020IntroHidden ?? false;
bool getIsValentines2021IntroHidden(AppState state) =>
    state?.settingState?.isValentines2021IntroHidden ?? false;

String getFontFamily(AppState state) {
  if ((state?.settingState?.useNMSFont ?? false) == true) return nmsFontFamily;

  return (state?.settingState?.fontFamily ?? defaultFontFamily);
}

bool getUseAltGlyphs(AppState state) =>
    state?.settingState?.useAltGlyphs ?? true;

int getLastPlatformIndex(AppState state) =>
    state?.settingState?.lastPlatformIndex ?? 0;

bool getIntroComplete(AppState state) =>
    state?.settingState?.introComplete ?? false;

bool getOnlineMeetup2020(AppState state) =>
    state?.settingState?.onlineMeetup2020 ?? false;

HomepageType getHomepageType(AppState state) =>
    state?.settingState?.homepageType ?? HomepageType.custom;

List<LocaleKey> getCustomMenuOrder(AppState state) =>
    state?.settingState?.customMenuOrder ?? List.empty(growable: true);

bool getDontShowSpoilerAlert(AppState state) =>
    state?.settingState?.dontShowSpoilerAlert ?? false;

String getPlayerName(AppState state) => state?.settingState?.playerName;

int getUselessButtonTaps(AppState state) =>
    state?.settingState?.uselessButtonTaps;

bool getIsPatron(AppState state) => state?.settingState?.isPatron;

bool getShowFestiveBackground(AppState state) {
  if (!isValentinesPeriod()) return false;

  return state?.settingState?.showFestiveBackground ?? true;
}

int getSelectedNewsPage(AppState state) {
  return state?.settingState?.lastNewsPageIndex;
}

bool getMergeInventoryQuantities(AppState state) {
  return state?.settingState?.mergeInventoryQuantities ?? true;
}
