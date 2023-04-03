import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/alienPuzzle/alien_puzzle.dart';
import '../../contracts/alienPuzzle/alien_puzzle_type.dart';
import 'interface/i_alien_puzzle_json_repository.dart';

class AlienPuzzleJsonRepository extends BaseJsonService
    implements IAlienPuzzleJsonRepository {
  //
  @override
  Future<ResultWithValue<List<AlienPuzzle>>> getAll(
      context, List<AlienPuzzleType> puzzleTypes) async {
    try {
      List responseDetailsJson = await getListfromJson(context,
          getTranslations().fromKey(LocaleKey.alienPuzzleJson) + '.json');
      List<AlienPuzzle> alienPuzzles =
          responseDetailsJson.map((m) => AlienPuzzle.fromJson(m)).toList();
      List<AlienPuzzle> filtered = alienPuzzles.toList();
      if (puzzleTypes.isNotEmpty) {
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
        await getAll(context, List.empty());
    if (alienPuzzlesResult.hasFailed) {
      return ResultWithValue(
        false,
        AlienPuzzle.fromJson(<String, dynamic>{}),
        alienPuzzlesResult.errorMessage,
      );
    }
    try {
      AlienPuzzle selectedAlienPuzzle =
          alienPuzzlesResult.value.firstWhere((r) => r.id == id);
      return ResultWithValue<AlienPuzzle>(true, selectedAlienPuzzle, '');
    } catch (exception) {
      getLog().e(
          "AlienPuzzleJsonRepository getById ($id) Exception: ${exception.toString()}");
      return ResultWithValue<AlienPuzzle>(
        false,
        AlienPuzzle.fromJson(<String, dynamic>{}),
        exception.toString(),
      );
    }
  }
}
