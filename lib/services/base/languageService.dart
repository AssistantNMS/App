import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../constants/AppAvailableLanguages.dart';

class LanguageService implements ILanguageService {
  @override
  LocalizationMap defaultLanguageMap() =>
      LocalizationMap(LocaleKey.english, 'en', 'gb');

  @override
  List<LocalizationMap> getLocalizationMaps() => supportedLanguageMaps;

  List<Locale> supportedLocales() =>
      getLocalizationMaps().map((l) => Locale(l.code, "")).toList();
  List<LocaleKey> supportedLanguages() =>
      getLocalizationMaps().map((l) => l.name).toList();
  List<String> supportedLanguagesCodes() =>
      getLocalizationMaps().map((l) => l.code).toList();
}
