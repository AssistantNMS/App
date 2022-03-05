import '../../constants/AppImage.dart';

class SelectedPlatform {
  String title;
  String icon;
  int index;
  SelectedPlatform(this.title, this.icon, this.index);

  static SelectedPlatform defaultFont() => SelectedPlatform(
        'PC',
        AppImage.platformPC,
        0,
      );

  static SelectedPlatform getFromValue(int platformIndex) {
    try {
      for (SelectedPlatform item in availablePlatforms) {
        if (item.index == platformIndex) {
          return item;
        }
      }
      return SelectedPlatform.defaultFont();
    } catch (ex) {
      //
    }
    return SelectedPlatform.defaultFont();
  }
}

List<SelectedPlatform> availablePlatforms = [
  SelectedPlatform.defaultFont(),
  SelectedPlatform('PS', AppImage.platformPS, 1),
  SelectedPlatform('XB', AppImage.platformXB, 2),
];
