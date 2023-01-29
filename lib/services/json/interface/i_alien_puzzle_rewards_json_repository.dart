import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../../contracts/alienPuzzle/alien_puzzle_reward.dart';

class IAlienPuzzleRewardsJsonRepository {
  //
  Future<ResultWithValue<List<AlienPuzzleReward>>> getAll(context) async {
    return ResultWithValue<List<AlienPuzzleReward>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<AlienPuzzleReward>> getById(context, String id) async {
    return ResultWithValue<AlienPuzzleReward>(
      false,
      AlienPuzzleReward.fromJson(<String, dynamic>{}),
      '',
    );
  }

  Future<ResultWithValue<List<AlienPuzzleReward>>> getByListOfIds(
      context, List<String> ids) async {
    return ResultWithValue<List<AlienPuzzleReward>>(
        false, List.empty(growable: true), '');
  }
}
