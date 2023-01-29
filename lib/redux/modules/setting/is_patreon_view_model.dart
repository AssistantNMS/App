import 'package:redux/redux.dart';

import '../../../contracts/redux/app_state.dart';
import 'selector.dart';

class IsPatreonViewModel {
  final bool isPatron;

  IsPatreonViewModel({
    required this.isPatron,
  });

  static IsPatreonViewModel fromStore(Store<AppState> store) =>
      IsPatreonViewModel(
        isPatron: getIsPatron(store.state),
      );
}
