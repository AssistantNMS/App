import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:meta/meta.dart';

import '../../constants/fonts.dart';
import '../enum/homepage_type.dart';

@immutable
class SettingState {
  final bool persistCart;
  final String selectedLanguage;
  final bool guidesIsCompact;
  final bool genericTileIsCompact;
  final bool showMaterialTheme;
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
  final int customHomePageColumnCount;

  const SettingState({
    required this.persistCart,
    required this.selectedLanguage,
    required this.guidesIsCompact,
    required this.genericTileIsCompact,
    required this.showMaterialTheme,
    required this.displayGenericItemColour,
    required this.isValentines2020IntroHidden,
    required this.isValentines2021IntroHidden,
    required this.useNMSFont,
    required this.fontFamily,
    required this.useAltGlyphs,
    required this.lastPlatformIndex,
    required this.introComplete,
    required this.onlineMeetup2020,
    required this.dontShowSpoilerAlert,
    required this.homepageType,
    required this.customMenuOrder,
    required this.playerName,
    required this.uselessButtonTaps,
    required this.isPatron,
    required this.showFestiveBackground,
    required this.lastNewsPageIndex,
    required this.mergeInventoryQuantities,
    required this.customHomePageColumnCount,
  });

  factory SettingState.initial() {
    return SettingState(
      persistCart: true,
      selectedLanguage: 'en',
      guidesIsCompact: false,
      genericTileIsCompact: true,
      showMaterialTheme: true,
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
      playerName: '',
      uselessButtonTaps: 0,
      isPatron: false,
      showFestiveBackground: true,
      lastNewsPageIndex: 0,
      mergeInventoryQuantities: true,
      customHomePageColumnCount: 0,
    );
  }

  SettingState copyWith({
    bool? persistCart,
    String? selectedLanguage,
    bool? guidesIsCompact,
    bool? genericTileIsCompact,
    bool? showMaterialTheme,
    bool? displayGenericItemColour,
    bool? isValentines2020IntroHidden,
    bool? isValentines2021IntroHidden,
    bool? useNMSFont,
    String? fontFamily,
    bool? useAltGlyphs,
    int? lastPlatformIndex,
    bool? introComplete,
    bool? onlineMeetup2020,
    bool? dontShowSpoilerAlert,
    HomepageType? homepageType,
    List<LocaleKey>? customMenuOrder,
    String? playerName,
    int? uselessButtonTaps,
    bool? isPatron,
    bool? showFestiveBackground,
    int? lastNewsPageIndex,
    bool? mergeInventoryQuantities,
    int? customHomePageColumnCount,
  }) {
    return SettingState(
      persistCart: persistCart ?? this.persistCart,
      guidesIsCompact: guidesIsCompact ?? this.guidesIsCompact,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      genericTileIsCompact: genericTileIsCompact ?? this.genericTileIsCompact,
      showMaterialTheme: showMaterialTheme ?? this.showMaterialTheme,
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
      customHomePageColumnCount:
          customHomePageColumnCount ?? this.customHomePageColumnCount,
    );
  }

  factory SettingState.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SettingState.initial();
    try {
      return SettingState(
        persistCart: readBoolSafe(json, 'persistCart'),
        selectedLanguage: readStringSafe(json, 'selectedLanguage'),
        guidesIsCompact: readBoolSafe(json, 'guidesIsCompact'),
        genericTileIsCompact: readBoolSafe(json, 'genericTileIsCompact'),
        showMaterialTheme: readBoolSafe(json, 'showMaterialTheme'),
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
        customMenuOrder: readListSafe(
          json,
          'customMenuOrder',
          (p) => (EnumToString.fromString(LocaleKey.values, p) ??
              LocaleKey.unknown),
        ).toList(),
        playerName: readStringSafe(json, 'playerName'),
        uselessButtonTaps: readIntSafe(json, 'uselessButtonTaps'),
        isPatron: readBoolSafe(json, 'isPatron'),
        showFestiveBackground: readBoolSafe(json, 'showFestiveBackground'),
        lastNewsPageIndex: readIntSafe(json, 'lastNewsPageIndex'),
        mergeInventoryQuantities:
            readBoolSafe(json, 'mergeInventoryQuantities'),
        customHomePageColumnCount:
            readIntSafe(json, 'customHomePageColumnCount'),
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
        'customHomePageColumnCount': customHomePageColumnCount,
      };
}
