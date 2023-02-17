import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'components/adaptive/app_shell.dart';
import 'contracts/redux/app_state.dart';
import 'env/environment_settings.dart';
import 'integration/dependency_injection.dart';
import 'redux/modules/create_store.dart';
import 'redux/modules/setting/actions.dart';
import 'redux/modules/setting/selector.dart';

class AssistantNMS extends StatefulWidget {
  final EnvironmentSettings env;
  const AssistantNMS(this.env, {Key? key}) : super(key: key);

  @override
  createState() => _AssistantNMSState();
}

class _AssistantNMSState extends State<AssistantNMS> {
  Store<AppState>? store;
  TranslationsDelegate _newLocaleDelegate =
      const TranslationsDelegate(newLocale: null);

  @override
  initState() {
    super.initState();
    initDependencyInjection(widget.env);
    initReduxState();

    if (kReleaseMode) {
      // initFirebaseAdMob();
    }
  }

  Future<AppState> initReduxState() async {
    Store<AppState> tempStore = await createStore();
    setState(() {
      store = tempStore;
    });

    _newLocaleDelegate = TranslationsDelegate(
      newLocale: Locale(getSelectedLanguage(tempStore.state)),
    );
    return tempStore.state;
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
    store!.dispatch(ChangeLanguageAction(locale.languageCode));
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
      store: store!,
      child: AppShell(
        newLocaleDelegate: _newLocaleDelegate,
        onLocaleChange: _onLocaleChange,
      ),
    );
  }
}
