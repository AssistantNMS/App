import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/requiredItem.dart';
import 'package:assistantnms_app/integration/dependencyInjection.dart';
import 'package:assistantnms_app/pages/helloGames/misc/starshipScrapDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../../constants/AnalyticsEvent.dart';
import '../../../contracts/data/starshipScrap.dart';
import '../../../contracts/helloGames/starshipScrapDetailed.dart';
import '../../../contracts/redux/appState.dart';
import '../../../contracts/requiredItemDetails.dart';
import '../../../helpers/itemsHelper.dart';
import '../../../redux/modules/generic/genericItemViewModel.dart';

class StarshipScrapPage extends StatelessWidget {
  StarshipScrapPage({Key key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.starshipScrapPagePage);
  }

  Future<ResultWithValue<List<StarshipScrapDetailed>>> allScrapFuture(
      BuildContext futureCtx) async {
    ResultWithValue<List<StarshipScrap>> baseData =
        await getDataRepo().getStarshipScrapData(futureCtx);
    if (baseData.isSuccess == false) {
      return ResultWithValue<List<StarshipScrapDetailed>>(
          false, List.empty(), baseData.errorMessage);
    }

    List<RequiredItemDetails> requiredItems = List.empty(growable: true);
    for (StarshipScrap baseDataItem in baseData.value) {
      for (StarshipScrapItemDetail baseDataItemItem
          in baseDataItem.itemDetails) {
        if (requiredItems.any((r) => r.id == baseDataItemItem.id)) continue;

        ResultWithValue<RequiredItemDetails> reqDetailsResult =
            await requiredItemDetails(
          futureCtx,
          RequiredItem(id: baseDataItemItem.id),
        );
        if (reqDetailsResult.hasFailed) continue;

        requiredItems.add(reqDetailsResult.value);
      }
    }

    List<StarshipScrapDetailed> result = baseData.value
        .map((baseData) => StarshipScrapDetailed(
              shipType: baseData.shipType,
              shipClassType: baseData.shipClassType,
              itemDetails: baseData.itemDetails
                  .map((itemDetails) {
                    RequiredItemDetails reqItem = requiredItems.firstWhere(
                      (req) => req.id == itemDetails.id,
                      orElse: () => null,
                    );

                    if (reqItem == null) return null;

                    return StarshipScrapDetailedItemDetail(
                      id: itemDetails.id,
                      icon: reqItem.icon,
                      name: reqItem.name,
                      colour: reqItem.colour,
                      percentageChance: itemDetails.percentageChance,
                      amountMin: itemDetails.amountMin,
                      amountMax: itemDetails.amountMax,
                    );
                  })
                  .where((item) => item != null)
                  .toList(),
            ))
        .toList();
    return ResultWithValue<List<StarshipScrapDetailed>>(true, result, '');
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GenericItemViewModel>(
      converter: (store) => GenericItemViewModel.fromStore(store),
      builder: (_, viewModel) {
        return simpleGenericPageScaffold(
          context,
          title: getTranslations().fromKey(LocaleKey.starshipScrap),
          body: FutureBuilder(
            future: allScrapFuture(context),
            builder: (bodyCtx, asyncSnapshot) =>
                getBodyFromFuture(bodyCtx, asyncSnapshot, viewModel),
          ),
        );
      },
    );
  }

  Widget getBodyFromFuture(
    BuildContext bodyCtx,
    AsyncSnapshot<ResultWithValue<List<StarshipScrapDetailed>>> snapshot,
    GenericItemViewModel reduxViewModel,
  ) {
    Widget errorWidget = asyncSnapshotHandler(
      bodyCtx,
      snapshot,
      loader: () => getLoading().fullPageLoading(bodyCtx),
      isValidFunction:
          (ResultWithValue<List<StarshipScrapDetailed>> expResult) {
        if (expResult.hasFailed) return false;
        if (expResult.value == null) return false;
        return true;
      },
    );
    if (errorWidget != null) return errorWidget;

    return StarshipScrapDisplay(
      starScraps: snapshot.data.value,
      displayGenericItemColour: reduxViewModel.displayGenericItemColour,
    );
  }
}