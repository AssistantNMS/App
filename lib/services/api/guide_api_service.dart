import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../constants/api_urls.dart';
import '../../contracts/generated/guide_meta_view_model.dart';
import '../../integration/dependency_injection.dart';

class GuideApiService extends BaseApiService {
  GuideApiService() : super(getEnv().baseApi);

  Future<ResultWithValue<GuideMetaViewModel>> getGuideMetaData(
      String guid) async {
    try {
      final response = await apiGet('${ApiUrls.guideMeta}/$guid');
      if (response.hasFailed) {
        return ResultWithValue<GuideMetaViewModel>(
          false,
          GuideMetaViewModel.fromRawJson('{}'),
          response.errorMessage,
        );
      }
      var guideMeta = GuideMetaViewModel.fromRawJson(response.value);
      return ResultWithValue(true, guideMeta, '');
    } catch (exception) {
      getLog().e("getGuideMetaData Api Exception: ${exception.toString()}");
      return ResultWithValue<GuideMetaViewModel>(
        false,
        GuideMetaViewModel.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  Future<ResultWithValue<GuideMetaViewModel>> getGuideDetails(
      String guid, String language) async {
    try {
      final response = await apiGet('${ApiUrls.guideMeta}/$guid/$language');
      if (response.hasFailed) {
        return ResultWithValue<GuideMetaViewModel>(
          false,
          GuideMetaViewModel.fromRawJson('{}'),
          response.errorMessage,
        );
      }
      var guideMeta = GuideMetaViewModel.fromRawJson(response.value);
      return ResultWithValue(true, guideMeta, '');
    } catch (exception) {
      getLog().e("getGuideDetails Api Exception: ${exception.toString()}");
      return ResultWithValue<GuideMetaViewModel>(
        false,
        GuideMetaViewModel.fromRawJson('{}'),
        exception.toString(),
      );
    }
  }

  Future<Result> likeGuide(String guid) async {
    try {
      final response = await apiPost('${ApiUrls.guideMeta}/$guid', '{}');
      if (response.hasFailed) {
        return Result(false, response.errorMessage);
      }
      return Result(true, '');
    } catch (exception) {
      getLog().e("likeGuide Api Exception: ${exception.toString()}");
      return Result(false, exception.toString());
    }
  }
}
