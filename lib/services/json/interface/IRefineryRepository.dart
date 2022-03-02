import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../../contracts/processor.dart';

class IRefineryRepository {
  //
  Future<ResultWithValue<Processor>> getById(context, String procId) async {
    return ResultWithValue<Processor>(false, Processor(), '');
  }

  Future<ResultWithValue<List<Processor>>> getAll(context) async {
    return ResultWithValue<List<Processor>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<List<Processor>>> getByOutput(
      context, String id) async {
    return ResultWithValue<List<Processor>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<List<Processor>>> getByInput(
      context, String id) async {
    return ResultWithValue<List<Processor>>(
        false, List.empty(growable: true), '');
  }
}
