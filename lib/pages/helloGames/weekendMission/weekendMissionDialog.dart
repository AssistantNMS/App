import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../../constants/AppAnimation.dart';
import '../../../constants/Modal.dart';

import '../../../components/common/chatBubble.dart';
import '../../../contracts/weekendMission.dart';

class WeekendMissionDialogPage extends StatefulWidget {
  final MessageFlow messageFlow;
  WeekendMissionDialogPage(this.messageFlow);
  @override
  _WeekendMissionDialogWidget createState() =>
      _WeekendMissionDialogWidget(this.messageFlow);
}

class _WeekendMissionDialogWidget extends State<WeekendMissionDialogPage> {
  MessageFlow messageFlow;
  List<Widget Function()> chatBubbles = List.empty(growable: true);

  _WeekendMissionDialogWidget(this.messageFlow) {
    for (var npcMsg in messageFlow.incomingMessages) {
      chatBubbles.add(() => weekendMissionBubble(npcMsg));
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget Function()> localChatBubbles = List.empty(growable: true);
    localChatBubbles.addAll(chatBubbles);

    var localOptions = messageFlow?.options ?? List.empty(growable: true);
    if (localOptions.length == 0) {
      localChatBubbles.add(() => Padding(
            padding: EdgeInsets.only(top: 12, left: 6),
            child: userLeftBubble(context,
                getTranslations().fromKey(LocaleKey.conversationEnded)),
          ));
      localChatBubbles.add(() => emptySpace8x());
    }

    if (localOptions.length > 0) {
      localChatBubbles.add(
        () => Padding(
          padding: EdgeInsets.only(top: 12),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: localOptions
                .map((opt) => GestureDetector(
                      child: currentUserBubbleOption(context, opt.name),
                      onTap: () {
                        this.setState(() {
                          chatBubbles
                              .add(() => currentUserBubble(context, opt.name));
                          for (var npcMsg in opt.ifSelected.incomingMessages) {
                            chatBubbles.add(() => weekendMissionBubble(npcMsg));
                          }
                          messageFlow = opt.ifSelected;
                        });
                      },
                    ))
                .toList(),
          ),
        ),
      );
    }

    return AnimatedSize(
      duration: AppAnimation.modal,
      child: Container(
        constraints: modalDefaultSize(context),
        child: Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: localChatBubbles.length,
              itemBuilder: (_, int index) => localChatBubbles[index](),
              shrinkWrap: true,
            ),
            if (localOptions.length == 0) ...[
              positionCenterBottom(
                FloatingActionButton(
                  child: Icon(Icons.close),
                  foregroundColor:
                      getTheme().fabForegroundColourSelector(context),
                  backgroundColor: getTheme().fabColourSelector(context),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget positionCenterBottom(Widget child) {
    return Positioned(
      child: child,
      left: 0,
      right: 0,
      bottom: 10,
    );
  }
}
