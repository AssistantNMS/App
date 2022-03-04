import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/guide/guide.dart';
import '../../contracts/guide/guideListItem.dart';

import 'interface/IGuidesRepository.dart';

class GuidesJsonRepository extends BaseJsonService
    implements IGuidesRepository {
  //
  @override
  Future<ResultWithValue<List<Guide>>> getAll(context) async {
    try {
      List availableGuidesJson = await getListfromJson(
          context, getTranslations().fromKey(LocaleKey.guidesJson));

      List<Guide> guides = List.empty(growable: true);
      for (var guideItemDynamic in availableGuidesJson) {
        GuideListItem guideListItem = GuideListItem.fromJson(guideItemDynamic);
        var guideDynamic = await getJsonGuide(
            context, guideListItem.folder, guideListItem.file);
        Guide guideContent = Guide.fromJson(guideDynamic, guideListItem.folder);
        if (guideContent != null) {
          guides.add(guideContent);
        }
        guides.sort((a, b) => b.date.compareTo(a.date));
      }
      return ResultWithValue<List<Guide>>(true, guides, '');
    } catch (exception) {
      getLog().e('GuideJsonService Exception');
      return ResultWithValue<List<Guide>>(
          false, List.empty(growable: true), exception.toString());
    }
  }
}
