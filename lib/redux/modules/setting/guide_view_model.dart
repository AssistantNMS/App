import 'package:redux/redux.dart';

import '../../../contracts/redux/app_state.dart';
import 'selector.dart';

class GuideViewModel {
  final String selectedLanguage;

  GuideViewModel({
    required this.selectedLanguage,
    //
  });

  static GuideViewModel fromStore(Store<AppState> store) {
    return GuideViewModel(
      selectedLanguage: getSelectedLanguage(store.state),
      //
    );
  }
}
