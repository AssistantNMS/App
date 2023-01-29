import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/online_meetup2020_submission_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/generated/online_meetup2020_submission_view_model.dart';
import '../../integration/dependency_injection.dart';

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
