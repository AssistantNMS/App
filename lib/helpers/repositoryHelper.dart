import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../services/json/GenericJsonRepository.dart';
import '../services/json/RefineryJsonRepository.dart';

GenericJsonRepository Function(LocaleKey detailsJson) initRepo =
    (LocaleKey detailsJson) => GenericJsonRepository(detailsJson);

RefineryJsonRepository Function(LocaleKey detailsJson, bool isRefiner)
    initRefineryRepo = (LocaleKey detailsJson, isRefiner) =>
        RefineryJsonRepository(detailsJson, isRefiner);

final getAllItemsLocaleKeys = [
  LocaleKey.rawMaterialsJson,
  LocaleKey.tradeItemsJson,
  LocaleKey.productsJson,
  LocaleKey.otherItemsJson,
  LocaleKey.curiosityJson,
  LocaleKey.technologiesJson,
  LocaleKey.cookingJson,
  LocaleKey.buildingsJson,
  // LocaleKey.upgradeModulesJson,
  LocaleKey.constructedTechnologyJson,
  LocaleKey.proceduralProductsJson,
  LocaleKey.technologyModulesJson,
];
