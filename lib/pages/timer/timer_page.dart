import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/redux/app_state.dart';
import '../../contracts/timer/timer_item.dart';
import '../../integration/dependency_injection.dart';
import '../../redux/modules/timer/timer_view_model.dart';
import 'add_edit_timer_page.dart';
import 'timer_page_view.dart';

class TimersPage extends StatelessWidget {
  TimersPage({Key? key}) : super(key: key) {
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
          viewModel.timers,
          viewModel.editTimer,
          viewModel.removeTimer,
          key: Key('numTimers${viewModel.timers.length}'),
        ),
        fab: FloatingActionButton(
          onPressed: () async {
            TimerItem? temp = await getNavigation().navigateAsync<TimerItem>(
              context,
              navigateTo: (context) => AddEditTimerPage(
                TimerItem.addOrEditDefault(context),
                false,
              ),
            );
            if (temp == null) return;
            if (temp.name == null) return;

            viewModel.addTimer(temp);
            await getLocalNotification().scheduleTimerNotification(
              temp.completionDate,
              temp.notificationId,
              getTranslations().fromKey(LocaleKey.timerComplete),
              temp.name!,
            );
          },
          heroTag: 'addTimer',
          child: const Icon(Icons.add),
          foregroundColor: getTheme().fabForegroundColourSelector(context),
          backgroundColor: getTheme().fabColourSelector(context),
        ),
      ),
    );
  }
}
