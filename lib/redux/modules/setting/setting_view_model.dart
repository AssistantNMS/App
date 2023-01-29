import '../../../contracts/enum/homepage_type.dart';
import 'package:redux/redux.dart';

import '../../../contracts/redux/app_state.dart';
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
    required this.persistCart,
    required this.selectedLanguage,
    required this.guidesIsCompact,
    required this.genericTileIsCompact,
    required this.showMaterialTheme,
    required this.displayGenericItemColour,
    required this.fontFamily,
    required this.useAltGlyphs,
    required this.homepageType,
    required this.dontShowSpoilerAlert,
    required this.uselessButtonTaps,
    required this.isPatron,
    required this.showFestiveBackground,
    required this.platformIndex,
    required this.mergeInventoryQuantities,
    required this.customHomePageColumnCount,
    //
    required this.toggleGuideIsCompact,
    required this.toggleGenericTileIsCompact,
    required this.toggleShowMaterialTheme,
    required this.toggleDisplayGenericItemColour,
    required this.setFontFamily,
    required this.toggleAltGlyphs,
    required this.setHomepageType,
    required this.setShowSpoilerAlert,
    required this.increaseUselessButtonTaps,
    required this.setIsPatron,
    required this.toggleShowFestiveBackground,
    required this.setPlatformIndex,
    required this.toggleMergeInventoryQuantities,
    required this.setCustomHomePageColumnCount,
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
