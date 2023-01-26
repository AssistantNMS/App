import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/techTree/unlockableTechTree.dart';
import '../../integration/dependencyInjection.dart';
import 'unlockableTechTreeComponents.dart';

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
