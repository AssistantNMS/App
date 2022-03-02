import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/alienPuzzle/alienPuzzle.dart';
import '../../contracts/alienPuzzle/alienPuzzleType.dart';
import 'interface/IAlienPuzzleJsonRepository.dart';

class AlienPuzzleJsonRepository extends BaseJsonService
    implements IAlienPuzzleJsonRepository {
  //
  @override
  Future<ResultWithValue<List<AlienPuzzle>>> getAll(
      context, List<AlienPuzzleType> puzzleTypes) async {
    try {
      List responseDetailsJson = await this.getListfromJson(
          context, getTranslations().fromKey(LocaleKey.alienPuzzleJson));
      List<AlienPuzzle> alienPuzzles =
          responseDetailsJson.map((m) => AlienPuzzle.fromJson(m)).toList();
      List<AlienPuzzle> filtered = alienPuzzles.toList();
      if (puzzleTypes.length > 0) {
        filtered = alienPuzzles
            .where((a) => puzzleTypes.any((pt) => pt == a.type))
            .toList();
      }
      return ResultWithValue<List<AlienPuzzle>>(true, filtered, '');
    } catch (exception) {
      getLog()
          .e("AlienPuzzleJsonRepository Exception: ${exception.toString()}");
      return ResultWithValue<List<AlienPuzzle>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<AlienPuzzle>> getById(context, String id) async {
    ResultWithValue<List<AlienPuzzle>> alienPuzzlesResult =
        await this.getAll(context, List.empty());
    if (alienPuzzlesResult.hasFailed) {
      return ResultWithValue(
          false, AlienPuzzle(), alienPuzzlesResult.errorMessage);
    }
    try {
      AlienPuzzle selectedAlienPuzzle =
          alienPuzzlesResult.value.firstWhere((r) => r.id == id);
      return ResultWithValue<AlienPuzzle>(true, selectedAlienPuzzle, '');
    } catch (exception) {
      getLog().e(
          "AlienPuzzleJsonRepository getById ($id) Exception: ${exception.toString()}");
      return ResultWithValue<AlienPuzzle>(
          false, AlienPuzzle(), exception.toString());
    }
  }
}
