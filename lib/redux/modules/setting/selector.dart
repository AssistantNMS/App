import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../../constants/Fonts.dart';
import '../../../contracts/enum/homepage_type.dart';
import '../../../contracts/redux/app_state.dart';
import '../../../helpers/dateHelper.dart';

String getSelectedLanguage(AppState state) =>
    state.settingState.selectedLanguage;

bool getGuidesIsCompact(AppState state) => state.settingState.guidesIsCompact;

bool getGenericTileIsCompact(AppState state) =>
    state.settingState.genericTileIsCompact;

bool getShowMaterialTheme(AppState state) =>
    state.settingState.showMaterialTheme;

bool getDisplayGenericItemColour(AppState state) =>
    state.settingState.displayGenericItemColour;

bool getIsValentines2020IntroHidden(AppState state) =>
    state.settingState.isValentines2020IntroHidden;
bool getIsValentines2021IntroHidden(AppState state) =>
    state.settingState.isValentines2021IntroHidden;

String getFontFamily(AppState state) {
  if (state.settingState.useNMSFont == true) return nmsFontFamily;

  return state.settingState.fontFamily;
}

bool getUseAltGlyphs(AppState state) => state.settingState.useAltGlyphs;

int getLastPlatformIndex(AppState state) =>
    state.settingState.lastPlatformIndex;

bool getIntroComplete(AppState state) => state.settingState.introComplete;

bool getOnlineMeetup2020(AppState state) => state.settingState.onlineMeetup2020;

HomepageType getHomepageType(AppState state) => state.settingState.homepageType;

List<LocaleKey> getCustomMenuOrder(AppState state) =>
    state.settingState.customMenuOrder;

bool getDontShowSpoilerAlert(AppState state) =>
    state.settingState.dontShowSpoilerAlert;

bool getShowFestiveBackground(AppState state) =>
    state.settingState.showFestiveBackground;

int getCustomHomePageColumnCount(AppState state) {
  int safeValue = state.settingState.customHomePageColumnCount;
  if (safeValue < 1) return 0;
  return safeValue;
}

String getPlayerName(AppState state) => state.settingState.playerName;

int getUselessButtonTaps(AppState state) =>
    state.settingState.uselessButtonTaps;

bool getIsPatron(AppState state) => state.settingState.isPatron;

bool showFestiveBackground(AppState state) {
  if (!isInFestivePeriod()) return false;

  return state.settingState.showFestiveBackground;
}

int getSelectedNewsPage(AppState state) {
  return state.settingState.lastNewsPageIndex;
}

bool getMergeInventoryQuantities(AppState state) {
  return state.settingState.mergeInventoryQuantities;
}
