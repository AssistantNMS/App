import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:assistantnms_app/components/adaptive/windowsTitleBar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wiredash/wiredash.dart';

import '../../constants/HomepageItems.dart';
import '../../constants/Routes.dart';
import '../../contracts/redux/appState.dart';
import '../../env/appVersionNum.dart';
import '../../integration/dependencyInjection.dart';
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
              introViewModel,
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
    IntroViewModel introViewModel,
    Map<String, Widget Function(BuildContext)> routes,
    List<LocalizationsDelegate<dynamic>> localizationsDelegates,
    List<Locale> supportedLocales,
  ) {
    ScrollBehavior scrollBehavior;
    if (isDesktop) {
      scrollBehavior = const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      );
    }

    String initialRoute = HomepageItem.defaultHomepageItem().routeToNamed;
    try {
      initialRoute = HomepageItem.getByType(
        introViewModel.homepageType,
      ).routeToNamed;
    } catch (ex) {
      initialRoute = HomepageItem.defaultHomepageItem().routeToNamed;
    }

    Widget matApp = Wiredash(
      projectId: getEnv().wiredashProjectId,
      secret: getEnv().wiredashSecret,
      options: WiredashOptionsData(
        locale: getTranslations().getLocaleFromKey(
          introViewModel.currentLanguage,
        ),
      ),
      feedbackOptions: WiredashFeedbackOptions(
        email: EmailPrompt.optional,
        collectMetaData: (metaData) => metaData
          // information about your app build
          ..buildNumber = appsBuildNum.toString()
          ..buildVersion = appsBuildName
          ..buildCommit = appsCommit

          // custom metadata
          ..custom['currentLang'] = introViewModel.currentLanguage
          ..custom['isPatron'] = introViewModel.isPatron,
      ),
      child: MaterialApp(
        key: key,
        title: 'Assistant for No Man\'s Sky',
        theme: theme,
        darkTheme: darkTheme,
        initialRoute: initialRoute,
        routes: routes,
        scrollBehavior: scrollBehavior,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
      ),
    );

    if (!isWindows) return matApp;

    return MaterialApp(
      theme: theme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: WindowsTitleBar('Assistant for No Man\'s Sky'),
        body: matApp,
      ),
    );
  }
}
