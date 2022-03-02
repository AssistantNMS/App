import '../../../contracts/redux/appState.dart';
import '../../../contracts/redux/titleState.dart';

List<String> getOwned(AppState state) =>
    state?.titleState?.owned ?? TitleState.initial().owned;
