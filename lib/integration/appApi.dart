import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import '../constants/api_urls.dart';
import '../constants/app_config.dart';
import '../contracts/generated/addFriendCodeViewModel.dart';
import '../contracts/generated/friendCodeViewModel.dart';
import '../contracts/generated/nomNomInventoryViewModel.dart';
import '../contracts/generated/stripeDonationViewModel.dart';
import '../contracts/nmsfm/nmsfmTrackData.dart';
import 'dependencyInjection.dart';

class AppApi extends BaseApiService {
  AppApi() : super(getEnv().baseApi);

  Future<ResultWithValue<String>> stripeCharge(
      String token, double amount) async {
    StripeDonationViewModel vm = StripeDonationViewModel.fromRawJson('{}');
    vm.amount = amount;
    vm.token = token;
    vm.currency = AppConfig.stripeCurrencyCode;
    vm.isGooglePay = isAndroid;
    try {
      final response = await apiPost(ApiUrls.stripeCharge, vm.toJson());
      return response;
    } catch (exception) {
      getLog().e("stripeCharge Exception: ${exception.toString()}");
      return ResultWithValue<String>(false, '', exception.toString());
    }
  }

  Future<ResultWithValue<List<FriendCodeViewModel>>> getFriendCodes(
      bool showPc, bool showPs4, bool showXb1, bool showNsw) async {
    List<String> queryParamsList = [
      'showPc=$showPc',
      'showPs4=$showPs4',
      'showXb1=$showXb1',
      'showNsw=$showNsw'
    ];
    String queryParams = queryParamsList.join('&');
    try {
      final response = await apiGet('${ApiUrls.friendCode}?$queryParams');
      if (response.hasFailed) {
        return ResultWithValue<List<FriendCodeViewModel>>(
            false, List.empty(growable: true), response.errorMessage);
      }
      final List newsList = json.decode(response.value);
      List<FriendCodeViewModel> news =
          newsList.map((r) => FriendCodeViewModel.fromJson(r)).toList();
      return ResultWithValue(true, news, '');
    } catch (exception) {
      getLog().e("getFriendCodes Api Exception: ${exception.toString()}");
      return ResultWithValue<List<FriendCodeViewModel>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  Future<Result> submitFriendCode(AddFriendCodeViewModel vm) async {
    try {
      final response = await apiPost(ApiUrls.friendCode, vm.toRawJson());
      if (response.hasFailed) {
        return Result(false, response.errorMessage);
      }
      return Result(true, '');
    } catch (exception) {
      getLog().e("submitFriendCode Api Exception: ${exception.toString()}");
      return Result(false, exception.toString());
    }
  }

  Future<ResultWithValue<List<NmsfmTrackData>>> getNmsfmTrackList() async {
    try {
      final response = await apiGet(ApiUrls.nmsfm);
      if (response.hasFailed) {
        return ResultWithValue<List<NmsfmTrackData>>(
            false, List.empty(growable: true), response.errorMessage);
      }
      final List newsList = json.decode(response.value);
      List<NmsfmTrackData> news =
          newsList.map((r) => NmsfmTrackData.fromJson(r)).toList();
      return ResultWithValue(true, news, '');
    } catch (exception) {
      getLog().e("getNmsfmTrackList Api Exception: ${exception.toString()}");
      return ResultWithValue<List<NmsfmTrackData>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  Future<ResultWithValue<List<NomNomInventoryViewModel>>>
      getInventoryFromNomNom(String code) async {
    try {
      final response = await apiGet(ApiUrls.nomNomInv + '/' + code);
      if (response.hasFailed) {
        return ResultWithValue<List<NomNomInventoryViewModel>>(
            false, List.empty(), response.errorMessage);
      }
      final List newsList = json.decode(response.value);
      List<NomNomInventoryViewModel> news =
          newsList.map((r) => NomNomInventoryViewModel.fromJson(r)).toList();
      return ResultWithValue(true, news, '');
    } catch (exception) {
      getLog()
          .e("getInventoryFromNomNom Api Exception: ${exception.toString()}");
      return ResultWithValue<List<NomNomInventoryViewModel>>(
          false, List.empty(), exception.toString());
    }
  }
}
