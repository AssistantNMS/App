// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../../constants/AppDuration.dart';
import '../../../constants/Modal.dart';

import '../../../components/common/chat_bubble.dart';
import '../../../contracts/weekendMission.dart';

class WeekendMissionDialogPage extends StatefulWidget {
  final MessageFlow messageFlow;
  const WeekendMissionDialogPage(this.messageFlow, {Key? key})
      : super(key: key);

  @override
  _WeekendMissionDialogWidget createState() =>
      _WeekendMissionDialogWidget(messageFlow);
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

    var localOptions = messageFlow.options ?? List.empty(growable: true);
    if (localOptions.isEmpty) {
      localChatBubbles.add(() => Padding(
            padding: const EdgeInsets.only(top: 12, left: 6),
            child: userLeftBubble(context,
                getTranslations().fromKey(LocaleKey.conversationEnded)),
          ));
      localChatBubbles.add(() => const EmptySpace8x());
    }

    if (localOptions.isNotEmpty) {
      localChatBubbles.add(
        () => Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: localOptions
                .map((opt) => GestureDetector(
                      child: currentUserBubbleOption(context, opt.name),
                      onTap: () {
                        setState(() {
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
      duration: AppDuration.modal,
      child: Container(
        constraints: modalDefaultSize(context),
        child: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: localChatBubbles.length,
              itemBuilder: (_, int index) => localChatBubbles[index](),
              shrinkWrap: true,
            ),
            if (localOptions.isEmpty) ...[
              positionCenterBottom(
                FloatingActionButton(
                  child: const Icon(Icons.close),
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
