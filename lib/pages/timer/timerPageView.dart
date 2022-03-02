import 'dart:async';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/tilePresenters/timerTilePresenter.dart';
import '../../constants/AppAnimation.dart';
import '../../contracts/timer/timerItem.dart';
import '../../integration/dependencyInjection.dart';
import 'addEditTimerPage.dart';

class TimersPageView extends StatefulWidget {
  final List<TimerItem> timers;
  final void Function(TimerItem) editTimer;
  final void Function(String) deleteTimer;
  TimersPageView(this.timers, this.editTimer, this.deleteTimer, {Key key})
      : super(key: key);

  @override
  _TimersPageViewState createState() =>
      _TimersPageViewState(this.timers, this.editTimer, this.deleteTimer);
}

class _TimersPageViewState extends State<TimersPageView> {
  Timer _timer;
  final List<TimerItem> timers;
  final void Function(TimerItem) editTimer;
  final void Function(String) deleteTimer;
  _TimersPageViewState(this.timers, this.editTimer, this.deleteTimer) {
    initTimer();
  }

  initTimer({TimerItem newTimer}) {
    if (_timer != null && _timer.isActive) _timer.cancel();
    _timer = Timer.periodic(AppAnimation.oneSec, (Timer t) {
      var hasValidTimers = timers.any(
        (t) => t.completionDate.isAfter(DateTime.now()),
      );
      var newTimerIsNotValid =
          newTimer == null || newTimer.completionDate.isBefore(DateTime.now());
      if (hasValidTimers == false && newTimerIsNotValid == true) {
        if (_timer != null && _timer.isActive) _timer.cancel();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (timers == null || timers.length == 0) {
      return listWithScrollbar(
        itemCount: 1,
        itemBuilder: (context, index) => Container(
          child: Text(
            getTranslations().fromKey(LocaleKey.noItems),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20),
          ),
          margin: EdgeInsets.only(top: 30),
        ),
      );
    }

    Function(TimerItem) onEdit = (TimerItem currentItem) async {
      TimerItem temp = await getNavigation().navigateAsync<TimerItem>(
        context,
        navigateTo: (context) => AddEditTimerPage(currentItem, false),
      );
      if (temp == null || !(temp is TimerItem)) return;
      editTimer(temp);
      await getLocalNotification()
          .removeScheduledTimerNotification(temp.notificationId);
      await getLocalNotification().scheduleTimerNotification(
        temp.completionDate,
        temp.notificationId,
        getTranslations().fromKey(LocaleKey.timerComplete),
        temp.name,
      );
      initTimer(newTimer: temp);
    };

    var presenter = (BuildContext presenterContext, TimerItem timer) =>
        timerTilePresenter(
            presenterContext, timer, onEdit, (String id) => deleteTimer(id));

    return SearchableList<TimerItem>(
      getSearchListFutureFromList(
        timers,
        compare: (a, b) => a.completionDate.compareTo(b.completionDate),
      ),
      listItemDisplayer: presenter,
      listItemSearch: (TimerItem req, String searchText) => true,
      key: Key('View-numTimers${timers.length}'),
    );
  }

  @override
  void dispose() {
    if (_timer != null && _timer.isActive) _timer.cancel();
    super.dispose();
  }
}
