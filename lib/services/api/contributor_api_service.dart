import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../../constants/api_urls.dart';
import '../../contracts/generated/contributor_view_model.dart';
import '../../integration/dependency_injection.dart';

class ContributorApiService extends BaseApiService {
  ContributorApiService() : super(getEnv().baseApi);

  Future<ResultWithValue<List<ContributorViewModel>>> getContributors() async {
    try {
      final response = await apiGet(ApiUrls.contributor);
      if (response.hasFailed) {
        return ResultWithValue<List<ContributorViewModel>>(
            false, List.empty(growable: true), response.errorMessage);
      }
      final List newsList = json.decode(response.value);
      var news = newsList.map((r) => ContributorViewModel.fromJson(r)).toList();
      return ResultWithValue(true, news, '');
    } catch (exception) {
      getLog().e("contributors Api Exception: ${exception.toString()}");
      return ResultWithValue<List<ContributorViewModel>>(
          false, List.empty(growable: true), exception.toString());
    }
  }
}
