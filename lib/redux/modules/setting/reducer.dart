import 'package:redux/redux.dart';

import '../../../contracts/redux/settingState.dart';
import 'actions.dart';

final settingReducer = combineReducers<SettingState>([
  TypedReducer<SettingState, ChangeLanguageAction>(_editLanguage),
  TypedReducer<SettingState, ToggleIsGuidesCompact>(_toggleIsGuideCompact),
  TypedReducer<SettingState, ToggleIsGenericTileCompact>(
      _toggleIsGenericTileCompact),
  TypedReducer<SettingState, ToggleShowMaterialTheme>(_toggleShowMaterialTheme),
  TypedReducer<SettingState, ToggleDisplayGenericItemColour>(
      _toggleDisplayGenericItemColour),
  TypedReducer<SettingState, HideValentines2020Intro>(_hideValentines2020Intro),
  TypedReducer<SettingState, HideValentines2021Intro>(_hideValentines2021Intro),
  TypedReducer<SettingState, SetFontFamily>(_setFontFamily),
  TypedReducer<SettingState, ToggleAltGlyphs>(_toggleAltGlyphs),
  TypedReducer<SettingState, SetLastPlatformIndex>(_setLastPlatformIndex),
  TypedReducer<SettingState, ToggleIntroComplete>(_toggleIntroComplete),
  TypedReducer<SettingState, HideOnlineMeetup2020>(_hideOnlineMeetup2020),
  TypedReducer<SettingState, SelectHomePageType>(_selectHomePageType),
  TypedReducer<SettingState, SetCustomMenuOrder>(_setCustomMenuOrder),
  TypedReducer<SettingState, DontShowSpoilerAlert>(_dontShowSpoilerAlert),
  TypedReducer<SettingState, SetPlayerName>(_setPlayerName),
  TypedReducer<SettingState, UselessButtonTap>(_uselessButtonTap),
  TypedReducer<SettingState, SetIsPatron>(_setIsPatron),
  TypedReducer<SettingState, SetNewsPage>(_setNewsPage),
  TypedReducer<SettingState, ToggleShowFestiveBackground>(
      _toggleShowFestiveBackground),
  TypedReducer<SettingState, ToggleMergeInventoryQuantities>(
      _toggleMergeInventoryQuantities),
  TypedReducer<SettingState, SetCustomHomePageColumnCount>(
      _setCustomHomePageColumnCount),
]);

SettingState _editLanguage(SettingState state, ChangeLanguageAction action) {
  return state.copyWith(selectedLanguage: action.languageCode);
}

SettingState _toggleIsGuideCompact(SettingState state, _) =>
    state.copyWith(guidesIsCompact: !state.guidesIsCompact);
SettingState _toggleIsGenericTileCompact(SettingState state, _) =>
    state.copyWith(genericTileIsCompact: !state.genericTileIsCompact);
SettingState _toggleShowMaterialTheme(SettingState state, _) =>
    state.copyWith(showMaterialTheme: !state.showMaterialTheme);
SettingState _toggleDisplayGenericItemColour(SettingState state, _) =>
    state.copyWith(displayGenericItemColour: !state.displayGenericItemColour);
SettingState _hideValentines2020Intro(SettingState state, _) =>
    state.copyWith(isValentines2020IntroHidden: true);
SettingState _hideValentines2021Intro(SettingState state, _) =>
    state.copyWith(isValentines2021IntroHidden: true);

SettingState _setFontFamily(SettingState state, SetFontFamily action) =>
    state.copyWith(
      useNMSFont: false,
      fontFamily: action.fontFamily,
    );

SettingState _toggleAltGlyphs(SettingState state, _) =>
    state.copyWith(useAltGlyphs: !state.useAltGlyphs);
SettingState _setLastPlatformIndex(
        SettingState state, SetLastPlatformIndex action) =>
    state.copyWith(lastPlatformIndex: action.lastPlatformIndex);
SettingState _toggleIntroComplete(SettingState state, _) =>
    state.copyWith(introComplete: !state.introComplete);
SettingState _hideOnlineMeetup2020(SettingState state, _) =>
    state.copyWith(onlineMeetup2020: !state.onlineMeetup2020);
SettingState _selectHomePageType(
        SettingState state, SelectHomePageType action) =>
    state.copyWith(homepageType: action.homepageType);
SettingState _setCustomMenuOrder(
        SettingState state, SetCustomMenuOrder action) =>
    state.copyWith(customMenuOrder: action.customOrder);
SettingState _dontShowSpoilerAlert(
        SettingState state, DontShowSpoilerAlert action) =>
    state.copyWith(dontShowSpoilerAlert: !state.dontShowSpoilerAlert);
SettingState _setPlayerName(SettingState state, SetPlayerName action) =>
    state.copyWith(playerName: action.playerName);
SettingState _uselessButtonTap(SettingState state, UselessButtonTap action) =>
    state.copyWith(uselessButtonTaps: (state.uselessButtonTaps ?? 0) + 1);
SettingState _setIsPatron(SettingState state, SetIsPatron action) =>
    state.copyWith(isPatron: action.newIsPatron);
SettingState _setNewsPage(SettingState state, SetNewsPage action) =>
    state.copyWith(lastNewsPageIndex: action.newsSelection);
SettingState _toggleShowFestiveBackground(
        SettingState state, ToggleShowFestiveBackground action) =>
    state.copyWith(showFestiveBackground: !state.showFestiveBackground);
SettingState _toggleMergeInventoryQuantities(
        SettingState state, ToggleMergeInventoryQuantities action) =>
    state.copyWith(mergeInventoryQuantities: !state.mergeInventoryQuantities);
SettingState _setCustomHomePageColumnCount(
        SettingState state, SetCustomHomePageColumnCount action) =>
    state.copyWith(customHomePageColumnCount: action.columnCount);
