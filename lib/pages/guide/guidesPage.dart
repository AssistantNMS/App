import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/guide_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/guide/guide.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/searchHelpers.dart';
import '../../redux/modules/setting/settingViewModel.dart';
import '../../services/json/GuidesJsonRepository.dart';

class GuidesPage extends StatelessWidget {
  GuidesPage({Key? key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.guidePage);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingViewModel>(
      converter: (store) => SettingViewModel.fromStore(store),
      builder: (_, viewModel) => getBody(context, viewModel),
    );
  }

  Widget getBody(BuildContext context, SettingViewModel viewModel) {
    GuidesJsonRepository _guidesRepo = GuidesJsonRepository();
    var presenter = viewModel.guidesIsCompact
        ? (BuildContext context, NmsGuide guideDetails,
                {void Function()? onTap}) =>
            compactGuideTilePresenter(context, guideDetails)
        : (BuildContext context, NmsGuide guideDetails,
                {void Function()? onTap}) =>
            guideTilePresenter(context, guideDetails);
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.guides),
      actions: [
        ActionItem(
          icon: viewModel.guidesIsCompact
              ? Icons.photo_size_select_actual
              : Icons.list,
          onPressed: () => viewModel.toggleGuideIsCompact(),
        )
      ],
      body: SearchableList<NmsGuide>(
        () => _guidesRepo.getAll(context),
        listItemDisplayer: presenter,
        listItemSearch: searchGuide,
        hintText: getTranslations().fromKey(LocaleKey.searchGuide),
        key: Key(viewModel.guidesIsCompact ? 'compact' : 'notCompact'),
      ),
    );
  }
}
