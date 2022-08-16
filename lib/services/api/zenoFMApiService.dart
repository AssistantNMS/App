import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../constants/Nmsfm.dart';
import '../../contracts/nmsfm/zenoFMNowPlaying.dart';

class ZenoFMApiService extends BaseApiService {
  ZenoFMApiService() : super(ZenoFMUrlTemplate.baseUrl);

  Future<ResultWithValue<ZenoFmNowPlaying>> getNowPlaying(
      String zenoFMId) async {
    String urlPath =
        ZenoFMUrlTemplate.artistPollUrl.replaceAll('{0}', zenoFMId);
    try {
      final response = await apiGet(urlPath);
      if (response.hasFailed) {
        return ResultWithValue<ZenoFmNowPlaying>(
            false, ZenoFmNowPlaying.defaultObj(), response.errorMessage);
      }
      var nowPlayingResp = ZenoFmNowPlaying.fromRawJson(response.value);
      return ResultWithValue(true, nowPlayingResp, '');
    } catch (exception) {
      getLog().e("ZenoFM Api Exception: ${exception.toString()}");
      return ResultWithValue<ZenoFmNowPlaying>(
          false, ZenoFmNowPlaying.defaultObj(), exception.toString());
    }
  }
}
