import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import 'allItemsPageComponent.dart';

class AllItemsPage extends StatelessWidget {
  const AllItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.allItems),
      body: const AllItemsPageComponent(isHomePage: false),
    );
  }
}
