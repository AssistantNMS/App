import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/alien_puzzle.dart';
import '../../constants/app_duration.dart';
import '../../constants/Modal.dart';
import '../../contracts/alienPuzzle/alienPuzzle.dart';
import '../../contracts/alienPuzzle/alienPuzzleReward.dart';
import '../../integration/dependencyInjection.dart';
import '../../pages/alienPuzzles/alienPuzzlesRewardPage.dart';
import '../../pages/generic/genericPageDescripHighlightText.dart';
import '../common/chat_bubble.dart';
import '../tilePresenters/alien_puzzle_reward_odds_tile_presenter.dart';

class AlienPuzzleModalBottomSheet extends StatefulWidget {
  final AlienPuzzle alienPuzzle;
  const AlienPuzzleModalBottomSheet(this.alienPuzzle, {Key? key})
      : super(key: key);

  @override
  _AlienPuzzleModalBottomSheetWidget createState() =>
      // ignore: no_logic_in_create_state
      _AlienPuzzleModalBottomSheetWidget(alienPuzzle);
}

class _AlienPuzzleModalBottomSheetWidget
    extends State<AlienPuzzleModalBottomSheet> {
  bool showOptions = true;
  bool isLoadingRewards = false;
  AlienPuzzle alienPuzzle;
  List<Option> localOptions = List.empty(growable: true);
  List<Widget Function()> rewardBubbles = List.empty(growable: true);
  List<Widget Function()> chatBubbles = List.empty(growable: true);

  _AlienPuzzleModalBottomSheetWidget(this.alienPuzzle) {
    for (var npcMsg in alienPuzzle.incomingMessages) {
      chatBubbles.add(
        () => alienPuzzleBubble(
          textWithHighlightTags(
            context,
            npcMsg,
            List.empty(),
            textAlign: TextAlign.left,
          ),
        ),
      );
    }
    localOptions = alienPuzzle.options;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget Function()> localChatBubbles = List.empty(growable: true);
    localChatBubbles.addAll(chatBubbles);

    if (localOptions.isEmpty) {
      localChatBubbles.add(() => Padding(
            padding: const EdgeInsets.only(top: 12, left: 6),
            child: userLeftBubble(context,
                getTranslations().fromKey(LocaleKey.conversationEnded)),
          ));
      localChatBubbles.add(() => const EmptySpace8x());
    }

    if (localOptions.isNotEmpty && showOptions) {
      localChatBubbles.add(
        () => Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: localOptions
                .map((opt) => GestureDetector(
                      child: currentUserBubbleOption(context, opt.name),
                      onTap: () async {
                        var isTextEmpty = opt.text.isEmpty;
                        var isRewardsListEmpty = opt.rewardIds.isEmpty;
                        if (isTextEmpty && isRewardsListEmpty) {
                          getNavigation().pop(context);
                          return;
                        }

                        setState(() {
                          showOptions = false;
                          isLoadingRewards = true;
                          chatBubbles.add(
                            () => currentUserFromWidgetBubble(
                              context,
                              textWithHighlightTags(
                                context,
                                opt.name,
                                List.empty(),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          );
                          if (opt.text.isNotEmpty) {
                            chatBubbles.add(
                              () => alienPuzzleBubble(
                                textWithHighlightTags(
                                  context,
                                  opt.text,
                                  List.empty(),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            );
                          }
                        });

// Handle basic flow
                        ResultWithValue<List<AlienPuzzleReward>>
                            alienRewardsResult =
                            await getAlienPuzzleRewardsRepo()
                                .getByListOfIds(context, opt.rewardIds);
                        if (alienRewardsResult.hasFailed) {
                          setState(() {
                            isLoadingRewards = false;
                          });
                          return;
                        }

                        var changeChoiceButton = Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: NegativeButton(
                            title: getTranslations()
                                .fromKey(LocaleKey.changeChoice),
                            onTap: () async {
                              setState(() {
                                showOptions = true;
                                localOptions = alienPuzzle.options;
                                rewardBubbles = List.empty(growable: true);
                              });
                            },
                          ),
                        );

                        List<Widget> rewardsChatBubble = [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: userLeftBubble(context,
                                getTranslations().fromKey(LocaleKey.noRewards)),
                          ),
                          changeChoiceButton,
                        ];

                        if (alienRewardsResult.value.length == 1 &&
                            alienRewardsResult.value[0].rewards.length == 1) {
                          var rewardToDisplay =
                              alienRewardsResult.value[0].rewards[0];
                          var needToEnrich =
                              alienPuzzleRewardItemRequiresAdditionalData
                                  .contains(rewardToDisplay.type);
                          var detailItem =
                              alienRewardsResult.value[0].rewards[0];
                          var childWidget = (needToEnrich)
                              ? alienPuzzleRewardOddsGetDetailsItemTilePresenter(
                                  context, detailItem)
                              : alienPuzzleRewardOddsTilePresenter(
                                  context, detailItem);
                          rewardsChatBubble = [
                            Card(
                              margin: const EdgeInsets.only(
                                  top: 12, left: 8, right: 8),
                              child: childWidget,
                            ),
                            changeChoiceButton,
                          ];
                        } else if (alienRewardsResult.value.isNotEmpty) {
                          rewardsChatBubble = [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, right: 8),
                              child: PositiveButton(
                                title: getTranslations()
                                    .fromKey(LocaleKey.viewPossibleRewards)
                                    .replaceAll(
                                      '{0}',
                                      alienRewardsResult.value.length
                                          .toString(),
                                    ),
                                onTap: () async {
                                  await getNavigation().navigateAsync(
                                    context,
                                    navigateTo: (context) =>
                                        AlienPuzzlesRewardPage(
                                      alienRewardsResult.value,
                                    ),
                                  );
                                },
                              ),
                            ),
                            changeChoiceButton
                          ];
                        }

// // Handle advanced flow
                        if (opt.interactionId.isNotEmpty) {
                          var nextAlienPuzzleResult = await getAlienPuzzleRepo()
                              .getById(context, opt.interactionId);
                          if (nextAlienPuzzleResult.hasFailed) {
                            if (opt.rewardIds.isNotEmpty) {
                              setState(() {
                                isLoadingRewards = false;
                                rewardBubbles.addAll(
                                  rewardsChatBubble.map((chat) => () => chat),
                                );
                              });
                              return;
                            }
                            setState(() {
                              isLoadingRewards = false;
                            });
                            return;
                          }

                          List<Widget Function()> newChatBubbles =
                              List.empty(growable: true);
                          for (var npcMsg
                              in nextAlienPuzzleResult.value.incomingMessages) {
                            newChatBubbles.add(
                              () => alienPuzzleBubble(
                                textWithHighlightTags(
                                  context,
                                  npcMsg,
                                  List.empty(),
                                ),
                              ),
                            );
                          }
                          setState(() {
                            isLoadingRewards = false;
                            chatBubbles.addAll(newChatBubbles);
                            showOptions = true;
                            localOptions = nextAlienPuzzleResult.value.options;
                          });
                          return;
                        }

                        setState(() {
                          isLoadingRewards = false;
                          rewardBubbles.addAll(
                            rewardsChatBubble.map((chat) => () => chat),
                          );
                        });
                      },
                    ))
                .toList(),
          ),
        ),
      );
    }

    localChatBubbles.addAll(rewardBubbles);

    if (isLoadingRewards) {
      localChatBubbles
          .add(() => Center(child: getLoading().smallLoadingIndicator()));
    }

    return AnimatedSize(
      duration: AppDuration.modal,
      child: Container(
        constraints: modalDefaultSize(context),
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: localChatBubbles.length,
          itemBuilder: (_, int index) => localChatBubbles[index](),
          shrinkWrap: true,
        ),
      ),
    );
  }
}
