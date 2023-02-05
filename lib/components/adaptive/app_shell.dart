import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:assistantnms_app/constants/app_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../constants/homepage_items.dart';
import '../../constants/nms_ui_constants.dart';
import '../../constants/routes.dart';
import '../../contracts/redux/app_state.dart';
import '../../env/app_version_num.dart';
import '../../redux/modules/setting/intro_view_model.dart';
import '../../theme/themes.dart';

class AppShell extends StatelessWidget {
  final TranslationsDelegate newLocaleDelegate;
  final void Function(Locale locale) onLocaleChange;

  const AppShell({
    Key? key,
    required this.onLocaleChange,
    required this.newLocaleDelegate,
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
    Key? key,
    ThemeData theme,
    ThemeData darkTheme,
    IntroViewModel introViewModel,
    Map<String, Widget Function(BuildContext)> routes,
    List<LocalizationsDelegate<dynamic>> localizationsDelegates,
    List<Locale> supportedLocales,
  ) {
    ScrollBehavior? scrollBehavior;
    if (isDesktop || isWeb) {
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

    Widget matApp = FeedbackWrapper(
      options: FeedbackOptions(
        buildNumber: appsBuildNum.toString(),
        buildVersion: appsBuildName,
        buildCommit: appsCommit,
        currentLang: introViewModel.currentLanguage,
        isPatron: introViewModel.isPatron,
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
        debugShowCheckedModeBanner: false,
      ),
    );

    if (isDesktop) {
      return MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: WindowTitleBar(
            title: 'Assistant for No Man\'s Sky',
            iconPath: AppImage.assistantNMSWindowIcon,
          ),
          body: matApp,
        ),
      );
    }

    return MaterialApp(
      theme: theme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: matApp),
    );
  }
}
