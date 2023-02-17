import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/techTree/unlockable_tech_tree.dart';
import '../../integration/dependency_injection.dart';
import 'unlockable_tech_tree_components.dart';

class UnlockableTechTreePage extends StatelessWidget {
  UnlockableTechTreePage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.unlockableTechTreePage);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResultWithValue<List<UnlockableTechTree>>>(
      future: getTechTreeRepo().getAll(context),
      builder: (BuildContext context,
          AsyncSnapshot<ResultWithValue<List<UnlockableTechTree>>> snapshot) {
        return basicGenericPageScaffold(
          context,
          title: getTranslations().fromKey(LocaleKey.techTree),
          body: getBody(context, snapshot),
        );
      },
    );
  }

  Widget getBody(BuildContext context,
      AsyncSnapshot<ResultWithValue<List<UnlockableTechTree>>> snapshot) {
    Widget? errorWidget = asyncSnapshotHandler(context, snapshot);
    if (errorWidget != null) return errorWidget;

    // return getTreeWithoutSecondLevel(context, snapshot.data.value);

    return ListView(
      shrinkWrap: true,
      children: [
        getTree(context, snapshot.data!.value),
      ],
    );
  }
}
