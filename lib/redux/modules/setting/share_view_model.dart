import 'package:redux/redux.dart';

import '../../../contracts/redux/app_state.dart';
import 'selector.dart';

class ShareViewModel {
  final String selectedLanguage;

  ShareViewModel({
    required this.selectedLanguage,
    //
  });

  static ShareViewModel fromStore(Store<AppState> store) {
    return ShareViewModel(
      selectedLanguage: getSelectedLanguage(store.state),
      //
    );
  }
}
