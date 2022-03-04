import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/processor.dart';

import 'interface/IRefineryRepository.dart';

class RefineryJsonRepository extends BaseJsonService
    implements IRefineryRepository {
  bool isRefiner;
  LocaleKey detailsJsonLocale;
  RefineryJsonRepository(this.detailsJsonLocale, this.isRefiner);
  //
  @override
  Future<ResultWithValue<List<Processor>>> getAll(context) async {
    //getAnalytics().trackEvent(AnalyticsEvent.loadRefineryJson);

    String detailJson = getTranslations().fromKey(detailsJsonLocale);
    try {
      List responseDetailsJson = await getListfromJson(context, detailJson);
      List<Processor> refinerDetails = responseDetailsJson
          .map((m) => Processor.fromJson(m, isRefiner))
          .toList();

      return ResultWithValue<List<Processor>>(true, refinerDetails, '');
    } catch (exception) {
      getLog().e(
          "RefinerJsonService $detailsJsonLocale Exception: ${exception.toString()}");
      return ResultWithValue<List<Processor>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<Processor>> getById(context, String procId) async {
    ResultWithValue<List<Processor>> allGenericItemsResult =
        await getAll(context);
    if (allGenericItemsResult.hasFailed) {
      return ResultWithValue(
          false, Processor(), allGenericItemsResult.errorMessage);
    }
    try {
      Processor selectedGeneric =
          allGenericItemsResult.value.firstWhere((r) => r.id == procId);
      return ResultWithValue<Processor>(true, selectedGeneric, '');
    } catch (exception) {
      getLog().e(
          "RefinerJsonService $detailsJsonLocale Exception: ${exception.toString()}");
      return ResultWithValue<Processor>(
          false, Processor(), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<List<Processor>>> getByOutput(
      context, String id) async {
    ResultWithValue<List<Processor>> refineryResult = await getAll(context);
    if (refineryResult.hasFailed) {
      return ResultWithValue(
          false, List.empty(growable: true), refineryResult.errorMessage);
    }
    try {
      List<Processor> selectedRefiner =
          refineryResult.value.where((r) => r.output.id == id).toList();
      return ResultWithValue<List<Processor>>(true, selectedRefiner, '');
    } catch (exception) {
      getLog().e(
          "getRefiner ($id) $detailsJsonLocale Exception: ${exception.toString()}");
      return ResultWithValue<List<Processor>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<List<Processor>>> getByInput(
      context, String id) async {
    ResultWithValue<List<Processor>> refineryResult = await getAll(context);
    if (refineryResult.hasFailed) {
      return ResultWithValue(
          false, List.empty(growable: true), refineryResult.errorMessage);
    }
    try {
      List<Processor> selectedRefiner = refineryResult.value
          .where((r) => r.inputs.any((i) => i.id == id))
          .toList();
      return ResultWithValue<List<Processor>>(true, selectedRefiner, '');
    } catch (exception) {
      getLog().e(
          "getRefiner ($id) $detailsJsonLocale Exception: ${exception.toString()}");
      return ResultWithValue<List<Processor>>(
          false, List.empty(growable: true), exception.toString());
    }
  }
}
