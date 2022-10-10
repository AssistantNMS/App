import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../../contracts/enum/homepageType.dart';
import '../base/persistToStorage.dart';

class ChangeLanguageAction extends PersistToStorage {
  final String languageCode;
  ChangeLanguageAction(this.languageCode);
}

class ToggleIsGuidesCompact extends PersistToStorage {}

class ToggleIsGenericTileCompact extends PersistToStorage {}

class ToggleShowMaterialTheme extends PersistToStorage {}

class ToggleDisplayGenericItemColour extends PersistToStorage {}

class HideValentines2020Intro extends PersistToStorage {}

class HideValentines2021Intro extends PersistToStorage {}

class SetFontFamily extends PersistToStorage {
  final String fontFamily;
  SetFontFamily(this.fontFamily);
}

class ToggleAltGlyphs extends PersistToStorage {}

class SetLastPlatformIndex extends PersistToStorage {
  final int lastPlatformIndex;
  SetLastPlatformIndex(this.lastPlatformIndex);
}

class ToggleIntroComplete extends PersistToStorage {}

class HideOnlineMeetup2020 extends PersistToStorage {}

class SelectHomePageType extends PersistToStorage {
  HomepageType homepageType;
  SelectHomePageType(this.homepageType);
}

class SetCustomMenuOrder extends PersistToStorage {
  List<LocaleKey> customOrder;
  SetCustomMenuOrder(this.customOrder);
}

class DontShowSpoilerAlert extends PersistToStorage {
  DontShowSpoilerAlert();
}

class SetPlayerName extends PersistToStorage {
  final String playerName;
  SetPlayerName(this.playerName);
}

class UselessButtonTap extends PersistToStorage {
  UselessButtonTap();
}

class SetIsPatron extends PersistToStorage {
  final bool newIsPatron;
  SetIsPatron(this.newIsPatron);
}

class ShowFestiveBackground extends PersistToStorage {
  final bool show;
  ShowFestiveBackground(this.show);
}

class SetNewsPage extends PersistToStorage {
  final int newsSelection;
  SetNewsPage(this.newsSelection);
}

class ToggleMergeInventoryQuantities extends PersistToStorage {
  ToggleMergeInventoryQuantities();
}
