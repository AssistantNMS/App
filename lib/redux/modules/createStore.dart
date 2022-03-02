import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/AppConfig.dart';
import '../../contracts/redux/appState.dart';
import '../middleware/localStorageMiddleware.dart';
import 'appReducer.dart';

Future<Store<AppState>> createStore() async {
  List<void Function(Store<AppState>, dynamic, void Function(dynamic))>
      middlewares = List.empty(growable: true);
  Map<String, dynamic> stateMap = Map<String, dynamic>();
  if (isAndroid || isiOS) {
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
