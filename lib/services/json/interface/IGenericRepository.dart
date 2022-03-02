import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import '../../../contracts/genericPageItem.dart';

class IGenericRepository {
  Future<ResultWithValue<List<GenericPageItem>>> getAll(context) async {
    return ResultWithValue<List<GenericPageItem>>(
        false, List.empty(growable: true), '');
  }

  Future<ResultWithValue<GenericPageItem>> getById(context, String id) async {
    return ResultWithValue<GenericPageItem>(false, GenericPageItem(), '');
  }

  Future<ResultWithValue<List<GenericPageItem>>> getByInputsId(
      context, String id) async {
    return ResultWithValue<List<GenericPageItem>>(
        false, List.empty(growable: true), '');
  }
}
