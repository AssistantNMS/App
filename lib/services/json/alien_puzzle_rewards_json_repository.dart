import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/alienPuzzle/alien_puzzle_reward.dart';

import 'interface/i_alien_puzzle_rewards_json_repository.dart';

class AlienPuzzleRewardsJsonRepository extends BaseJsonService
    implements IAlienPuzzleRewardsJsonRepository {
  //
  @override
  Future<ResultWithValue<List<AlienPuzzleReward>>> getAll(context) async {
    try {
      List responseDetailsJson = await getListfromJson(
          context,
          getTranslations().fromKey(LocaleKey.alienPuzzleRewardsJson) +
              '.json');
      List<AlienPuzzleReward> alienPuzzles = responseDetailsJson
          .map((m) => AlienPuzzleReward.fromJson(m))
          .toList();
      return ResultWithValue<List<AlienPuzzleReward>>(true, alienPuzzles, '');
    } catch (exception) {
      getLog().e(
          "AlienPuzzleRewardsJsonRepository Exception: ${exception.toString()}");
      return ResultWithValue<List<AlienPuzzleReward>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<AlienPuzzleReward>> getById(context, String id) async {
    ResultWithValue<List<AlienPuzzleReward>> alienPuzzlesResult =
        await getAll(context);
    if (alienPuzzlesResult.hasFailed) {
      return ResultWithValue(
        false,
        AlienPuzzleReward.fromJson(<String, dynamic>{}),
        alienPuzzlesResult.errorMessage,
      );
    }
    try {
      AlienPuzzleReward selectedAlienPuzzle =
          alienPuzzlesResult.value.firstWhere((r) => r.rewardId == id);
      return ResultWithValue<AlienPuzzleReward>(true, selectedAlienPuzzle, '');
    } catch (exception) {
      getLog().e(
          "AlienPuzzleRewardJsonRepository getById ($id) Exception: ${exception.toString()}");
      return ResultWithValue<AlienPuzzleReward>(
        false,
        AlienPuzzleReward.fromJson(<String, dynamic>{}),
        exception.toString(),
      );
    }
  }

  @override
  Future<ResultWithValue<List<AlienPuzzleReward>>> getByListOfIds(
      context, List<String> ids) async {
    ResultWithValue<List<AlienPuzzleReward>> alienPuzzlesResult =
        await getAll(context);
    if (alienPuzzlesResult.hasFailed) {
      return ResultWithValue(
          false, List.empty(growable: true), alienPuzzlesResult.errorMessage);
    }
    try {
      List<AlienPuzzleReward> selectedAlienPuzzle = alienPuzzlesResult.value
          .where((r) => ids.contains(r.rewardId))
          .toList();
      return ResultWithValue<List<AlienPuzzleReward>>(
          true, selectedAlienPuzzle, '');
    } catch (exception) {
      getLog().e(
          "AlienPuzzleJsonRepository getByListOfIds ($ids) Exception: ${exception.toString()}");
      return ResultWithValue<List<AlienPuzzleReward>>(
          false, List.empty(growable: true), exception.toString());
    }
  }
}
