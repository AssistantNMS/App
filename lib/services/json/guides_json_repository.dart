import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/guide/guide.dart';
import '../../contracts/guide/guide_list_item.dart';

import 'interface/i_guides_repository.dart';

class GuidesJsonRepository extends BaseJsonService
    implements IGuidesRepository {
  //
  @override
  Future<ResultWithValue<List<NmsGuide>>> getAll(context) async {
    try {
      List availableGuidesJson = await getListFromJson(
          context, getTranslations().fromKey(LocaleKey.guidesJson) + '.json');

      List<NmsGuide> guides = List.empty(growable: true);
      for (var guideItemDynamic in availableGuidesJson) {
        ResultWithValue<NmsGuide> individualGuideResult = await getGuide(
          context,
          guideItemDynamic,
        );
        if (individualGuideResult.hasFailed) continue;
        guides.add(individualGuideResult.value);
        guides.sort((a, b) => b.date.compareTo(a.date));
      }
      return ResultWithValue<List<NmsGuide>>(true, guides, '');
    } catch (exception) {
      getLog().e('GuideJsonService Exception ' + exception.toString());
      return ResultWithValue<List<NmsGuide>>(
        false,
        List.empty(growable: true),
        exception.toString(),
      );
    }
  }

  Future<ResultWithValue<NmsGuide>> getGuide(
      BuildContext context, dynamic guideItemDynamic) async {
    try {
      NmsGuideListItem guideListItem =
          NmsGuideListItem.fromJson(guideItemDynamic);
      Map<String, dynamic>? guideDynamic = await getJsonGuide(
          context, guideListItem.folder, guideListItem.file + '.json');
      NmsGuide guideContent =
          NmsGuide.fromJson(guideDynamic, guideListItem.folder);
      return ResultWithValue<NmsGuide>(true, guideContent, '');
    } catch (exception) {
      getLog().e('GuideJsonService getGuide Exception ' + exception.toString());
      return ResultWithValue<NmsGuide>(
        false,
        NmsGuide.fromRawJson('{}', ''),
        exception.toString(),
      );
    }
  }
}
