import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../constants/AppAnimation.dart';
import '../../constants/Modal.dart';

class LogsModalBottomSheet extends StatelessWidget {
  const LogsModalBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: AppAnimation.modal,
      child: Container(
        constraints: modalFullHeightSize(context),
        child: TalkerScreen(
          talker: Talker.instance,
          options: const TalkerScreenOptions(appBarTitle: 'Logs'),
        ),
      ),
    );
  }
}
