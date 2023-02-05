import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

const String defaultFontFamily = 'Roboto';
const String nmsFontFamily = 'nms';
const String nmsExpeditionFontFamily = 'expedition';

class SelectedFont {
  LocaleKey localeKey;
  String fontFamily;
  SelectedFont(this.localeKey, this.fontFamily);

  static SelectedFont defaultFont() => SelectedFont(
        LocaleKey.defaultFont,
        defaultFontFamily,
      );

  static SelectedFont getFromFontFamily(String fontFamily) {
    try {
      for (SelectedFont item in availableFonts) {
        if (item.fontFamily == fontFamily) {
          return item;
        }
      }
      return SelectedFont.defaultFont();
    } catch (ex) {
      //
    }
    return SelectedFont.defaultFont();
  }
}

List<SelectedFont> availableFonts = [
  SelectedFont.defaultFont(),
  SelectedFont(
    LocaleKey.nmsThemed,
    nmsFontFamily,
  ),
  // SelectedFont(
  //   LocaleKey.about,
  //   nmsExpeditionFontFamily,
  // ),
];
