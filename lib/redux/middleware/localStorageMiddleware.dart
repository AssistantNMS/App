import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_config.dart';
import '../../contracts/redux/appState.dart';
import '../modules/base/persistToStorage.dart';

class LocalStorageMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    next(action);

    if (action is PersistToStorage) {
      getLog().i('saving to SharedPref');
      saveStateToPrefs(store.state);
    }
  }

  void saveStateToPrefs(AppState state) async {
    try {
      var stateString = json.encode(state.toJson());
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString(AppConfig.sharedPrefKey, stateString);
    } catch (exception) {
      getLog().e('saveStateToPrefs');
    }
  }
}
