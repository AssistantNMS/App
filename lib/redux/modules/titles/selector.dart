import '../../../contracts/redux/app_state.dart';

List<String> getOwned(AppState state) => state.titleState.owned;
bool getHideCompleted(AppState state) => state.titleState.hideCompleted;
