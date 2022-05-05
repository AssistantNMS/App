import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../constants/HomepageItems.dart';
import '../../constants/Routes.dart';
import '../../contracts/redux/appState.dart';
import '../../redux/modules/setting/introViewModel.dart';
import '../../theme/themes.dart';

class AppShell extends StatelessWidget {
  final TranslationsDelegate newLocaleDelegate;
  final void Function(Locale locale) onLocaleChange;
  const AppShell({
    Key key,
    this.onLocaleChange,
    this.newLocaleDelegate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getLog().i("main rebuild");
    Map<String, Widget Function(BuildContext)> routes = initNamedRoutes(
      onLocaleChange,
    );
    List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
      newLocaleDelegate,
      GlobalMaterialLocalizations.delegate, //provides localised strings
      GlobalWidgetsLocalizations.delegate, //provides RTL support
    ];
    return StoreConnector<AppState, IntroViewModel>(
      converter: (store) => IntroViewModel.fromStore(store),
      builder: (_, introViewModel) {
        String initialRoute = HomepageItem.defaultHomepageItem().routeToNamed;
        try {
          initialRoute = HomepageItem.getByType(
            introViewModel.homepageType,
          ).routeToNamed;
        } catch (ex) {
          initialRoute = HomepageItem.defaultHomepageItem().routeToNamed;
        }

        return AdaptiveTheme(
          initial: AdaptiveThemeMode.dark,
          light: getDynamicTheme(
            Brightness.light,
            introViewModel.fontFamily,
          ),
          dark: getDynamicTheme(
            Brightness.dark,
            introViewModel.fontFamily,
          ),
          builder: (ThemeData theme, ThemeData darkTheme) {
            return _androidApp(
              context,
              Key('android-${introViewModel.currentLanguage}'),
              theme,
              darkTheme,
              initialRoute,
              routes,
              localizationsDelegates,
              getLanguage().supportedLocales(),
            );
          },
        );
      },
    );
  }

  Widget _androidApp(
    BuildContext context,
    Key key,
    ThemeData theme,
    ThemeData darkTheme,
    String initialRoute,
    Map<String, Widget Function(BuildContext)> routes,
    List<LocalizationsDelegate<dynamic>> localizationsDelegates,
    List<Locale> supportedLocales,
  ) {
    return MaterialApp(
      key: key,
      shortcuts: <ShortcutActivator, Intent>{
        ...WidgetsApp.defaultShortcuts,
        const SingleActivator(LogicalKeyboardKey.space): const ActivateIntent(),
      },
      title: 'Assistant for No Man\'s Sky',
      theme: theme,
      darkTheme: darkTheme,
      initialRoute: initialRoute,
      routes: routes,
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
    );
  }

  // Widget _appleApp(
  //   BuildContext context,
  //   ThemeData theme,
  //   String initialRoute,
  //   Map<String, Widget Function(BuildContext)> routes,
  //   List<LocalizationsDelegate<dynamic>> localizationsDelegates,
  //   List<Locale> supportedLocales,
  // ) =>
  //     CupertinoApp(
  //       title: 'No Man\'s Sky Assistant',
  //       theme: toAppleTheme(theme),
  //       initialRoute: initialRoute,
  //       routes: routes,
  //       builder: (_, widget) => widget,
  //       localizationsDelegates: localizationsDelegates,
  //       supportedLocales: supportedLocales,
  //     );
}
