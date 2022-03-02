import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../../contracts/guide/guide.dart';

class IGuidesRepository {
  //
  Future<ResultWithValue<List<Guide>>> getAll(context) async {
    return ResultWithValue<List<Guide>>(false, List.empty(), '');
  }

  // Future<ResultWithValue<Guide>> getById(context, String id) async {
  //   return ResultWithValue<Guide>(false, Guide(), '');
  // }
}
