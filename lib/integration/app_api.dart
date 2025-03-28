import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/fishing/good_guy_free_bait_view_model.dart';

import '../constants/api_urls.dart';
import '../constants/app_config.dart';
import '../contracts/generated/add_friend_code_view_model.dart';
import '../contracts/generated/friend_code_view_model.dart';
import '../contracts/generated/nom_nom_inventory_view_model.dart';
import '../contracts/generated/stripe_donation_view_model.dart';
import '../contracts/nmsfm/nmsfm_track_data.dart';
import 'dependency_injection.dart';

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
    bool showPc,
    bool showPs4,
    bool showXb1,
    bool showNsw,
  ) async {
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

  Future<ResultWithValue<List<GoodGuyFreeBaitViewModel>>> getGoodGuyFreeBait(
      String lang) async {
    try {
      final response =
          await apiGet(ApiUrls.goodGuyFreeBait.replaceAll('{lang}', lang));
      if (response.hasFailed) {
        return ResultWithValue<List<GoodGuyFreeBaitViewModel>>(
            false, List.empty(), response.errorMessage);
      }
      final List newsList = json.decode(response.value);
      List<GoodGuyFreeBaitViewModel> news =
          newsList.map((r) => GoodGuyFreeBaitViewModel.fromJson(r)).toList();
      return ResultWithValue(true, news, '');
    } catch (exception) {
      getLog().e("getGoodGuyFreeBait Api Exception: ${exception.toString()}");
      return ResultWithValue<List<GoodGuyFreeBaitViewModel>>(
          false, List.empty(), exception.toString());
    }
  }

  Future<ResultWithValue<GoodGuyFreeBaitViewModel>> getGoodGuyFreeBaitForItem(
      String lang, String itemId) async {
    var baitResult = await getGoodGuyFreeBait(lang);
    GoodGuyFreeBaitViewModel? ggfItem = baitResult.value //
        .where((dev) => dev.appId == itemId)
        .firstOrNull;
    if (ggfItem == null) {
      return ResultWithValue(
        false,
        GoodGuyFreeBaitViewModel.fromRawJson('{}'),
        'Unable to find item with appId "$itemId"',
      );
    }
    return ResultWithValue(true, ggfItem, '');
  }
}
