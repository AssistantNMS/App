import '../../../contracts/redux/appState.dart';
import '../../../contracts/redux/titleState.dart';

List<String> getOwned(AppState state) =>
    state?.titleState?.owned ?? TitleState.initial().owned;
bool getHideCompleted(AppState state) =>
    state?.titleState?.hideCompleted ?? TitleState.initial().hideCompleted;
