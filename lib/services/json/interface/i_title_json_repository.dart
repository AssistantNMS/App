import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../../contracts/title_data.dart';

class ITitleJsonRepository {
  Future<ResultWithValue<List<TitleData>>> getAll(context) async {
    return ResultWithValue<List<TitleData>>(
        false, List.empty(growable: true), '');
  }
}
