import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../contracts/guide/guide.dart';
import '../../contracts/guide/guideListItem.dart';

import 'interface/IGuidesRepository.dart';

class GuidesJsonRepository extends BaseJsonService
    implements IGuidesRepository {
  //
  @override
  Future<ResultWithValue<List<NmsGuide>>> getAll(context) async {
    try {
      List availableGuidesJson = await getListfromJson(
          context, getTranslations().fromKey(LocaleKey.guidesJson));

      List<NmsGuide> guides = List.empty(growable: true);
      for (var guideItemDynamic in availableGuidesJson) {
        NmsGuideListItem guideListItem =
            NmsGuideListItem.fromJson(guideItemDynamic);
        var guideDynamic = await getJsonGuide(
            context, guideListItem.folder, guideListItem.file);
        NmsGuide guideContent =
            NmsGuide.fromJson(guideDynamic, guideListItem.folder);
        // ignore: unnecessary_null_comparison
        if (guideContent != null) {
          guides.add(guideContent);
        }
        guides.sort((a, b) => b.date.compareTo(a.date));
      }
      return ResultWithValue<List<NmsGuide>>(true, guides, '');
    } catch (exception) {
      getLog().e('GuideJsonService Exception');
      return ResultWithValue<List<NmsGuide>>(
          false, List.empty(growable: true), exception.toString());
    }
  }
}
