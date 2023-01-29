import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_config.dart';
import '../../contracts/redux/app_state.dart';
import '../middleware/localStorageMiddleware.dart';
import 'appReducer.dart';

Future<Store<AppState>> createStore() async {
  List<void Function(Store<AppState>, dynamic, void Function(dynamic))>
      middlewares = List.empty(growable: true);
  Map<String, dynamic> stateMap = <String, dynamic>{};
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var stateString = preferences.getString(AppConfig.sharedPrefKey);
    if (stateString != null) {
      stateMap = json.decode(stateString) as Map<String, dynamic>;
    }
    middlewares.add(LocalStorageMiddleware());
  } catch (exception) {
    getLog().e('createStore');
  }
  // middlewares.add(ValidationMiddleware());

  AppState initialState = AppState.initial();
  try {
    initialState = AppState.fromJson(stateMap);
  } catch (exception) {
    getLog().e('Failed to load initial state');
    initialState = AppState.initial();
  }

  return Store(
    appReducer,
    initialState: initialState,
    middleware: middlewares,
  );
}
