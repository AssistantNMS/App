import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../contracts/redux/appState.dart';
import '../../redux/modules/setting/isPatreonViewModel.dart';
import 'commonSeasonalExpeditionSeasonList.dart';
import 'seasonExpeditionConstants.dart';

class CustomSeasonalExpeditionSeasonListPage extends StatelessWidget {
  const CustomSeasonalExpeditionSeasonListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, IsPatreonViewModel>(
      converter: (store) => IsPatreonViewModel.fromStore(store),
      builder: (_, viewModel) {
        return FutureBuilder(
          future: currentAndPastExpeditions(context, isCustom: true),
          builder: (BuildContext futureContext,
              AsyncSnapshot<ResultWithValue<CurrentAndPastExpeditions>>
                  snapshot) {
            return simpleGenericPageScaffold(
              futureContext,
              title: getTranslations().fromKey(
                LocaleKey.seasonalExpeditionSeasons,
              ),
              body: getExpeditionBodyFromFuture(
                futureContext,
                viewModel,
                snapshot,
                isCustom: true,
              ),
            );
          },
        );
      },
    );
  }
}
