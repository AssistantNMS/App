import '../../constants/app_image.dart';

class SelectedPlatform {
  String title;
  String icon;
  int index;
  SelectedPlatform(this.title, this.icon, this.index);

  static SelectedPlatform defaultPlatform() => SelectedPlatform(
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
      return SelectedPlatform.defaultPlatform();
    } catch (ex) {
      //
    }
    return SelectedPlatform.defaultPlatform();
  }
}

List<SelectedPlatform> availablePlatforms = [
  SelectedPlatform.defaultPlatform(),
  SelectedPlatform('Playstation', AppImage.platformPS, 1),
  SelectedPlatform('Xbox', AppImage.platformXB, 2),
  SelectedPlatform('Nintendo Switch', AppImage.platformSW, 3),
];
