import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/titleData.dart';

import 'interface/ITitleJsonRepository.dart';

class TitleJsonRepository extends BaseJsonService
    implements ITitleJsonRepository {
  //
  Future<ResultWithValue<List<TitleData>>> getAll(context) async {
    try {
      String langJson = getTranslations().fromKey(LocaleKey.titlesJson);
      List list = await this.getListfromJson(context, langJson);
      List<TitleData> titleItems =
          list.map((m) => TitleData.fromJson(m)).toList();
      return ResultWithValue<List<TitleData>>(true, titleItems, '');
    } catch (exception) {
      getLog()
          .e("TitleJsonRepository getAll Exception: ${exception.toString()}");
      return ResultWithValue<List<TitleData>>(
          false, List.empty(growable: true), exception.toString());
    }
  }
}
