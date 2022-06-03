import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:meta/meta.dart';

import '../../constants/Fonts.dart';
import '../enum/homepageType.dart';

@immutable
class SettingState {
  final bool persistCart;
  final String selectedLanguage;
  final bool guidesIsCompact;
  final bool genericTileIsCompact;
  final bool showMaterialTheme;
  final bool isRelease118IntroHidden;
  final bool displayGenericItemColour;
  final bool isValentines2020IntroHidden;
  final bool isValentines2021IntroHidden;
  final bool useNMSFont;
  final String fontFamily;
  final bool useAltGlyphs;
  final int lastPlatformIndex;
  final bool introComplete;
  final bool onlineMeetup2020;
  final bool dontShowSpoilerAlert;
  final HomepageType homepageType;
  final List<LocaleKey> customMenuOrder;
  final String playerName;
  final int uselessButtonTaps;
  final bool isPatron;
  final bool showFestiveBackground;
  final int lastNewsPageIndex;
  final bool mergeInventoryQuantities;

  const SettingState({
    this.persistCart,
    this.selectedLanguage,
    this.guidesIsCompact,
    this.genericTileIsCompact,
    this.showMaterialTheme,
    this.isRelease118IntroHidden,
    this.displayGenericItemColour,
    this.isValentines2020IntroHidden,
    this.isValentines2021IntroHidden,
    this.useNMSFont,
    this.fontFamily,
    this.useAltGlyphs,
    this.lastPlatformIndex,
    this.introComplete,
    this.onlineMeetup2020,
    this.dontShowSpoilerAlert,
    this.homepageType,
    this.customMenuOrder,
    this.playerName,
    this.uselessButtonTaps,
    this.isPatron,
    this.showFestiveBackground,
    this.lastNewsPageIndex,
    this.mergeInventoryQuantities,
  });

  factory SettingState.initial() {
    return SettingState(
      persistCart: true,
      selectedLanguage: 'en',
      guidesIsCompact: false,
      genericTileIsCompact: true,
      showMaterialTheme: true,
      isRelease118IntroHidden: false,
      displayGenericItemColour: true,
      isValentines2020IntroHidden: false,
      isValentines2021IntroHidden: false,
      useNMSFont: false,
      fontFamily: defaultFontFamily,
      useAltGlyphs: true,
      lastPlatformIndex: 0,
      introComplete: false,
      onlineMeetup2020: false,
      dontShowSpoilerAlert: false,
      homepageType: HomepageType.custom,
      customMenuOrder: List.empty(growable: true),
      playerName: null,
      uselessButtonTaps: 0,
      isPatron: false,
      showFestiveBackground: true,
      lastNewsPageIndex: 0,
      mergeInventoryQuantities: true,
    );
  }

  SettingState copyWith({
    bool persistCart,
    String selectedLanguage,
    bool guidesIsCompact,
    bool genericTileIsCompact,
    bool showMaterialTheme,
    bool isRelease118IntroHidden,
    bool displayGenericItemColour,
    bool isValentines2020IntroHidden,
    bool isValentines2021IntroHidden,
    bool useNMSFont,
    String fontFamily,
    bool useAltGlyphs,
    int lastPlatformIndex,
    bool introComplete,
    bool onlineMeetup2020,
    bool dontShowSpoilerAlert,
    HomepageType homepageType,
    List<LocaleKey> customMenuOrder,
    String playerName,
    int uselessButtonTaps,
    bool isPatron,
    bool showFestiveBackground,
    int lastNewsPageIndex,
    bool mergeInventoryQuantities,
  }) {
    return SettingState(
      persistCart: persistCart ?? this.persistCart,
      guidesIsCompact: guidesIsCompact ?? this.guidesIsCompact,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      genericTileIsCompact: genericTileIsCompact ?? this.genericTileIsCompact,
      showMaterialTheme: showMaterialTheme ?? this.showMaterialTheme,
      isRelease118IntroHidden:
          isRelease118IntroHidden ?? this.isRelease118IntroHidden,
      displayGenericItemColour:
          displayGenericItemColour ?? this.displayGenericItemColour,
      isValentines2020IntroHidden:
          isValentines2020IntroHidden ?? this.isValentines2020IntroHidden,
      isValentines2021IntroHidden:
          isValentines2021IntroHidden ?? this.isValentines2021IntroHidden,
      useNMSFont: useNMSFont ?? this.useNMSFont,
      fontFamily: fontFamily ?? this.fontFamily,
      useAltGlyphs: useAltGlyphs ?? this.useAltGlyphs,
      lastPlatformIndex: lastPlatformIndex ?? this.lastPlatformIndex,
      introComplete: introComplete ?? this.introComplete,
      onlineMeetup2020: onlineMeetup2020 ?? this.onlineMeetup2020,
      dontShowSpoilerAlert: dontShowSpoilerAlert ?? this.dontShowSpoilerAlert,
      homepageType: homepageType ?? this.homepageType,
      customMenuOrder: customMenuOrder ?? this.customMenuOrder,
      playerName: playerName ?? this.playerName,
      uselessButtonTaps: uselessButtonTaps ?? this.uselessButtonTaps,
      isPatron: isPatron ?? this.isPatron,
      showFestiveBackground:
          showFestiveBackground ?? this.showFestiveBackground,
      lastNewsPageIndex: lastNewsPageIndex ?? this.lastNewsPageIndex,
      mergeInventoryQuantities:
          mergeInventoryQuantities ?? this.mergeInventoryQuantities,
    );
  }

  factory SettingState.fromJson(Map<String, dynamic> json) {
    if (json == null) return SettingState.initial();
    try {
      return SettingState(
        persistCart: readBoolSafe(json, 'persistCart'),
        selectedLanguage: readStringSafe(json, 'selectedLanguage'),
        guidesIsCompact: readBoolSafe(json, 'guidesIsCompact'),
        genericTileIsCompact: readBoolSafe(json, 'genericTileIsCompact'),
        showMaterialTheme: readBoolSafe(json, 'showMaterialTheme'),
        isRelease118IntroHidden: readBoolSafe(json, 'isRelease118IntroHidden'),
        displayGenericItemColour:
            readBoolSafe(json, 'displayGenericItemColour'),
        isValentines2020IntroHidden:
            readBoolSafe(json, 'isValentines2020IntroHidden'),
        isValentines2021IntroHidden:
            readBoolSafe(json, 'isValentines2021IntroHidden'),
        useNMSFont: readBoolSafe(json, 'useNMSFont'),
        fontFamily: readStringSafe(json, 'fontFamily'),
        useAltGlyphs: readBoolSafe(json, 'useAltGlyphs'),
        lastPlatformIndex: readIntSafe(json, 'lastPlatformIndex'),
        introComplete: readBoolSafe(json, 'introComplete'),
        onlineMeetup2020: readBoolSafe(json, 'onlineMeetup2020'),
        dontShowSpoilerAlert: readBoolSafe(json, 'dontShowSpoilerAlert'),
        homepageType: getHomepageTypeFomrInt(readIntSafe(json, 'homepageType')),
        customMenuOrder: readListSafe(json, 'customMenuOrder',
            (p) => EnumToString.fromString(LocaleKey.values, p)).toList(),
        playerName: readStringSafe(json, 'playerName'),
        uselessButtonTaps: readIntSafe(json, 'uselessButtonTaps'),
        isPatron: readBoolSafe(json, 'isPatron'),
        showFestiveBackground: readBoolSafe(json, 'showFestiveBackground'),
        lastNewsPageIndex: readIntSafe(json, 'lastNewsPageIndex'),
        mergeInventoryQuantities:
            readBoolSafe(json, 'mergeInventoryQuantities'),
      );
    } catch (exception) {
      return SettingState.initial();
    }
  }

  Map<String, dynamic> toJson() => {
        'persistCart': persistCart,
        'selectedLanguage': selectedLanguage,
        'guidesIsCompact': guidesIsCompact,
        'genericTileIsCompact': genericTileIsCompact,
        'showMaterialTheme': showMaterialTheme,
        'isRelease118IntroHidden': isRelease118IntroHidden,
        'displayGenericItemColour': displayGenericItemColour,
        'isValentines2020IntroHidden': isValentines2020IntroHidden,
        'isValentines2021IntroHidden': isValentines2021IntroHidden,
        'fontFamily': fontFamily,
        'useAltGlyphs': useAltGlyphs,
        'lastPlatformIndex': lastPlatformIndex,
        'introComplete': introComplete,
        'onlineMeetup2020': onlineMeetup2020,
        'dontShowSpoilerAlert': dontShowSpoilerAlert,
        'homepageType': homepageTypeToInt(homepageType),
        'customMenuOrder': customMenuOrder
            .map((cm) => EnumToString.convertToString(cm))
            .toList(),
        'playerName': playerName,
        'uselessButtonTaps': uselessButtonTaps,
        'isPatron': isPatron,
        'showFestiveBackground': showFestiveBackground,
        'lastNewsPageIndex': lastNewsPageIndex,
        'mergeInventoryQuantities': mergeInventoryQuantities,
      };
}
