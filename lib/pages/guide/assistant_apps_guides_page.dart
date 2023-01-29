import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/modalBottomSheet/googlelogin_modal_bottom_sheet.dart';
import '../../constants/storage_key.dart';
import '../../contracts/redux/app_state.dart';
import '../../redux/modules/setting/guideViewModel.dart';

class AssistantAppsGuidesPage extends StatelessWidget {
  const AssistantAppsGuidesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GuideViewModel>(
      converter: (store) => GuideViewModel.fromStore(store),
      builder: (_, viewModel) => getBody(context, viewModel),
    );
  }

  Widget getBody(BuildContext context, GuideViewModel viewModel) {
    return CachedFutureBuilder(
      future: getSecureStorageRepo().loadStringFromStorageCheckExpiry(
        StorageKey.assistantAppsApiToken,
      ),
      whileLoading: () => getLoading().fullPageLoading(context),
      whenDoneLoading: (ResultWithValue<String> tokenResult) {
        return GuideListPage(
          analyticsKey: 'GuideListPage',
          draftModel: GuideDraftModel(
            selectedLanguage: viewModel.selectedLanguage,
            assistantAppsToken: tokenResult.isSuccess ? tokenResult.value : '',
            deleteGuide: (_) {},
            updateGuide: (_) {},
            googleLogin: () {
              getNavigation().pop(context);
              adaptiveBottomModalSheet(
                context,
                hasRoundedCorners: true,
                builder: (_) => const GoogleLoginBottomSheet(),
              );
            },
          ),
        );
      },
    );
  }
}
