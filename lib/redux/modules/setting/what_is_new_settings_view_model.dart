import 'package:redux/redux.dart';

import '../../../contracts/redux/app_state.dart';
import 'selector.dart';

class WhatIsNewSettingsViewModel {
  final String selectedLanguage;

  WhatIsNewSettingsViewModel({
    required this.selectedLanguage,
  });

  static WhatIsNewSettingsViewModel fromStore(Store<AppState> store) =>
      WhatIsNewSettingsViewModel(
        selectedLanguage: getSelectedLanguage(store.state),
      );
}
