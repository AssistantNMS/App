import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../../contracts/alienPuzzle/alien_puzzle.dart';
import '../../../contracts/alienPuzzle/alien_puzzle_type.dart';

class IAlienPuzzleJsonRepository {
  //
  Future<ResultWithValue<List<AlienPuzzle>>> getAll(
      context, List<AlienPuzzleType> puzzleTypes) async {
    return ResultWithValue<List<AlienPuzzle>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<AlienPuzzle>> getById(context, String id) async {
    return ResultWithValue<AlienPuzzle>(
      false,
      AlienPuzzle.fromJson(<String, dynamic>{}),
      '',
    );
  }
}
