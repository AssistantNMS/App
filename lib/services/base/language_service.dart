import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../constants/app_available_languages.dart';

class LanguageService implements ILanguageService {
  @override
  LocalizationMap defaultLanguageMap() =>
      LocalizationMap(LocaleKey.english, 'en', 'gb');

  @override
  List<LocalizationMap> getLocalizationMaps() => supportedLanguageMaps;

  @override
  List<Locale> supportedLocales() =>
      getLocalizationMaps().map((l) => Locale(l.code, "")).toList();
  @override
  List<LocaleKey> supportedLanguages() =>
      getLocalizationMaps().map((l) => l.name).toList();
  @override
  List<String> supportedLanguagesCodes() =>
      getLocalizationMaps().map((l) => l.code).toList();
}
