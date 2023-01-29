import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/onlineMeetup2020SubmissionTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/generated/onlineMeetup2020SubmissionViewModel.dart';
import '../../integration/dependencyInjection.dart';

class OnlineMeetup2020SubmissionsPage extends StatelessWidget {
  OnlineMeetup2020SubmissionsPage({Key? key}) : super(key: key) {
    getAnalytics()
        .trackEvent(AnalyticsEvent.onlineMeetup2020SubmissionsListPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: 'NMS Online Meetup 2020',
      body: SearchableList<OnlineMeetup2020SubmissionViewModel>(
        () => getCommunityApiService().getAllOnlineMeetup2020(),
        listItemDisplayer: onlineMeetup2020SubmissionTilePresenter,
        listItemSearch: (OnlineMeetup2020SubmissionViewModel _, String __) =>
            false,
        minListForSearch: 10000,
        addFabPadding: true,
      ),
    );
  }
}
