import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/required_item.dart';
import 'package:assistantnms_app/integration/dependencyInjection.dart';
import 'package:assistantnms_app/pages/helloGames/misc/starshipScrapDisplay.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../../constants/analytics_event.dart';
import '../../../contracts/data/starship_scrap.dart';
import '../../../contracts/helloGames/starship_scrap_detailed.dart';
import '../../../contracts/redux/app_state.dart';
import '../../../contracts/required_item_details.dart';
import '../../../helpers/itemsHelper.dart';
import '../../../redux/modules/generic/genericItemViewModel.dart';

class StarshipScrapPage extends StatelessWidget {
  StarshipScrapPage({Key? key}) : super(key: key) {
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

    List<StarshipScrapDetailed> result = baseData.value.map((baseData) {
      List<StarshipScrapDetailedItemDetail> itemDetailsList =
          List.empty(growable: true);
      for (var itemDetails in baseData.itemDetails) {
        RequiredItemDetails? reqItem = requiredItems.firstWhereOrNull(
          (req) => req.id == itemDetails.id,
        );

        if (reqItem == null) continue;

        itemDetailsList.add(StarshipScrapDetailedItemDetail(
          id: itemDetails.id,
          icon: reqItem.icon,
          name: reqItem.name,
          colour: reqItem.colour,
          percentageChance: itemDetails.percentageChance,
          amountMin: itemDetails.amountMin,
          amountMax: itemDetails.amountMax,
        ));
      }
      return StarshipScrapDetailed(
        shipType: baseData.shipType,
        shipClassType: baseData.shipClassType,
        itemDetails: itemDetailsList,
      );
    }).toList();

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
          body: FutureBuilder<ResultWithValue<List<StarshipScrapDetailed>>>(
            future: allScrapFuture(context),
            builder: (bodyCtx, asyncSnapshot) => getBodyFromFuture(
              bodyCtx,
              asyncSnapshot,
              viewModel,
            ),
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
    Widget? errorWidget = asyncSnapshotHandler(
      bodyCtx,
      snapshot,
      loader: () => getLoading().fullPageLoading(bodyCtx),
      isValidFunction:
          (ResultWithValue<List<StarshipScrapDetailed>>? expResult) {
        if (expResult?.hasFailed ?? true) return false;
        if (expResult?.value == null) return false;
        return true;
      },
    );
    if (errorWidget != null) return errorWidget;

    return StarshipScrapDisplay(
      starScraps: snapshot.data!.value,
      displayGenericItemColour: reduxViewModel.displayGenericItemColour,
    );
  }
}
