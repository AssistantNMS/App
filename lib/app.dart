import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'components/adaptive/appShell.dart';
import 'contracts/redux/appState.dart';
import 'env/environmentSettings.dart';
import 'integration/dependencyInjection.dart';
import 'integration/firebase.dart';
import 'redux/modules/createStore.dart';
import 'redux/modules/setting/actions.dart';
import 'redux/modules/setting/selector.dart';

class MyApp extends StatefulWidget {
  final EnvironmentSettings _env;
  const MyApp(this._env, {Key key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _MyAppState createState() => _MyAppState(_env);
}

class _MyAppState extends State<MyApp> {
  final EnvironmentSettings _env;
  Store<AppState> store;
  TranslationsDelegate _newLocaleDelegate;

  _MyAppState(this._env);

  @override
  initState() {
    super.initState();
    tz.initializeTimeZones();
    initDependencyInjection(_env);
    initReduxState();

    if (kReleaseMode) {
      // initFirebaseAdMob();
    }

    _newLocaleDelegate ??= const TranslationsDelegate(newLocale: null);
  }

  Future<AppState> initReduxState() async {
    Store<AppState> tempStore = await createStore();
    setState(() {
      store = tempStore;
    });
    if (tempStore != null && tempStore.state != null) {
      _newLocaleDelegate = TranslationsDelegate(
        newLocale: Locale(getSelectedLanguage(tempStore.state)),
      );
      return tempStore.state;
    }
    return null;
  }

  // initReduxStateWithFCM() async {
  //   try {
  //     AppState state = await initReduxState();
  //     await getNotifications().subscribeToTopics(
  //         context, state?.settingState?.selectedLanguage ?? 'en');
  //   } catch (exception) {
  //     getLog().e('Failed to initReduxStateWithFCM');
  //   }
  // }

  void _onLocaleChange(Locale locale) {
    if (store == null) return;
    store.dispatch(ChangeLanguageAction(locale.languageCode));
    setState(() {
      _newLocaleDelegate = TranslationsDelegate(newLocale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (store == null) {
      return const MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: Text('Loading')),
        ),
      );
    }

    return StoreProvider(
      store: store,
      child: AppShell(
        newLocaleDelegate: _newLocaleDelegate,
        onLocaleChange: _onLocaleChange,
      ),
    );
  }
}
