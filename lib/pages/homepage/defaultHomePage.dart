import 'package:after_layout/after_layout.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/adaptive/homePageAppBar.dart';
import '../../components/drawer.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../helpers/updateHelper.dart';
import 'allItemsPageComponent.dart';

class DefaultHomePage extends StatefulWidget {
  const DefaultHomePage({Key? key}) : super(key: key);

  @override
  _DefaultHomePageState createState() => _DefaultHomePageState();
}

class _DefaultHomePageState extends State<DefaultHomePage>
    with AfterLayoutMixin<DefaultHomePage> {
  @override
  void afterFirstLayout(BuildContext context) => checkForUpdate(context);

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      appBar: homePageAppBar(getTranslations().fromKey(LocaleKey.title)),
      drawer: const AppDrawer(),
      body: const AllItemsPageComponent(isHomePage: true),
    );
  }
}
