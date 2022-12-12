import '../../../contracts/enum/homepageType.dart';
import 'package:redux/redux.dart';

import '../../../contracts/redux/appState.dart';
import 'actions.dart';
import 'selector.dart';

class SettingViewModel {
  final bool persistCart;
  final String selectedLanguage;
  final bool guidesIsCompact;
  final bool genericTileIsCompact;
  final bool showMaterialTheme;
  final bool displayGenericItemColour;
  final String fontFamily;
  final bool useAltGlyphs;
  final HomepageType homepageType;
  final bool dontShowSpoilerAlert;
  final int uselessButtonTaps;
  final bool isPatron;
  final bool showFestiveBackground;
  final int platformIndex;
  final bool mergeInventoryQuantities;
  final int customHomePageColumnCount;

  final Function() toggleGuideIsCompact;
  final Function() toggleGenericTileIsCompact;
  final Function() toggleShowMaterialTheme;
  final Function() toggleDisplayGenericItemColour;
  final Function(String fontFamily) setFontFamily;
  final Function() toggleAltGlyphs;
  final Function(HomepageType) setHomepageType;
  final Function() setShowSpoilerAlert;
  final Function() increaseUselessButtonTaps;
  final Function(bool) setIsPatron;
  final Function() toggleShowFestiveBackground;
  final Function(int) setPlatformIndex;
  final Function() toggleMergeInventoryQuantities;
  final Function(int) setCustomHomePageColumnCount;

  SettingViewModel({
    this.persistCart,
    this.selectedLanguage,
    this.guidesIsCompact,
    this.genericTileIsCompact,
    this.showMaterialTheme,
    this.displayGenericItemColour,
    this.fontFamily,
    this.useAltGlyphs,
    this.homepageType,
    this.dontShowSpoilerAlert,
    this.uselessButtonTaps,
    this.isPatron,
    this.showFestiveBackground,
    this.platformIndex,
    this.mergeInventoryQuantities,
    this.customHomePageColumnCount,
    //
    this.toggleGuideIsCompact,
    this.toggleGenericTileIsCompact,
    this.toggleShowMaterialTheme,
    this.toggleDisplayGenericItemColour,
    this.setFontFamily,
    this.toggleAltGlyphs,
    this.setHomepageType,
    this.setShowSpoilerAlert,
    this.increaseUselessButtonTaps,
    this.setIsPatron,
    this.toggleShowFestiveBackground,
    this.setPlatformIndex,
    this.toggleMergeInventoryQuantities,
    this.setCustomHomePageColumnCount,
  });

  static SettingViewModel fromStore(Store<AppState> store) => SettingViewModel(
        persistCart: true, // Legacy code. Don't know why I made this an option
        selectedLanguage: getSelectedLanguage(store.state),
        guidesIsCompact: getGuidesIsCompact(store.state),
        genericTileIsCompact: getGenericTileIsCompact(store.state),
        showMaterialTheme: getShowMaterialTheme(store.state),
        displayGenericItemColour: getDisplayGenericItemColour(store.state),
        fontFamily: getFontFamily(store.state),
        useAltGlyphs: getUseAltGlyphs(store.state),
        homepageType: getHomepageType(store.state),
        dontShowSpoilerAlert: getDontShowSpoilerAlert(store.state),
        uselessButtonTaps: getUselessButtonTaps(store.state),
        isPatron: getIsPatron(store.state),
        showFestiveBackground: getShowFestiveBackground(store.state),
        platformIndex: getLastPlatformIndex(store.state),
        mergeInventoryQuantities: getMergeInventoryQuantities(store.state),
        customHomePageColumnCount: getCustomHomePageColumnCount(store.state),
        //
        toggleGuideIsCompact: () => store.dispatch(ToggleIsGuidesCompact()),
        toggleGenericTileIsCompact: () =>
            store.dispatch(ToggleIsGenericTileCompact()),
        toggleShowMaterialTheme: () =>
            store.dispatch(ToggleShowMaterialTheme()),
        toggleDisplayGenericItemColour: () =>
            store.dispatch(ToggleDisplayGenericItemColour()),
        setFontFamily: (String fontFamily) =>
            store.dispatch(SetFontFamily(fontFamily)),
        toggleAltGlyphs: () => store.dispatch(ToggleAltGlyphs()),
        setHomepageType: (HomepageType homepageType) => store.dispatch(
          SelectHomePageType(homepageType),
        ),
        setShowSpoilerAlert: () => store.dispatch(DontShowSpoilerAlert()),
        increaseUselessButtonTaps: () => store.dispatch(UselessButtonTap()),
        setIsPatron: (bool isPatron) => store.dispatch(SetIsPatron(isPatron)),
        toggleShowFestiveBackground: () =>
            store.dispatch(ToggleShowFestiveBackground()),
        setPlatformIndex: (int platformIndex) =>
            store.dispatch(SetLastPlatformIndex(platformIndex)),
        toggleMergeInventoryQuantities: () =>
            store.dispatch(ToggleMergeInventoryQuantities()),
        setCustomHomePageColumnCount: (int columns) =>
            store.dispatch(SetCustomHomePageColumnCount(columns)),
      );
}
