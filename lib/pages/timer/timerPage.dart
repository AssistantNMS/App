import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/redux/appState.dart';
import '../../contracts/timer/timerItem.dart';
import '../../integration/dependencyInjection.dart';
import '../../redux/modules/timer/timerViewModel.dart';
import 'addEditTimerPage.dart';
import 'timerPageView.dart';

class TimersPage extends StatelessWidget {
  TimersPage() {
    getAnalytics().trackEvent(AnalyticsEvent.timerPage);
    if (isApple) {
      getLocalNotification().requestIosPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TimerViewModel>(
      converter: (store) => TimerViewModel.fromStore(store),
      builder: (_, viewModel) => basicGenericPageScaffold(
        context,
        title: getTranslations().fromKey(LocaleKey.timers),
        body: TimersPageView(
          viewModel.timers ?? [],
          viewModel.editTimer,
          viewModel.removeTimer,
          key: Key('numTimers${viewModel.timers.length}'),
        ),
        fab: FloatingActionButton(
          onPressed: () async {
            TimerItem temp = await getNavigation().navigateAsync<TimerItem>(
              context,
              navigateTo: (context) => AddEditTimerPage(
                TimerItem.addOrEditDefault(context),
                false,
              ),
            );
            if (temp == null || !(temp is TimerItem)) return;
            viewModel.addTimer(temp);
            await getLocalNotification().scheduleTimerNotification(
              temp.completionDate,
              temp.notificationId,
              getTranslations().fromKey(LocaleKey.timerComplete),
              temp.name,
            );
          },
          heroTag: 'addTimer',
          child: Icon(Icons.add),
          foregroundColor: getTheme().fabForegroundColourSelector(context),
          backgroundColor: getTheme().fabColourSelector(context),
        ),
      ),
    );
  }
}
