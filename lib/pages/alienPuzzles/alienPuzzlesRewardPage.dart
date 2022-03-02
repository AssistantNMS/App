import 'package:after_layout/after_layout.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/alienPuzzleRewardOddsTilePresenter.dart';
import '../../constants/AlienPuzzle.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../constants/AppImage.dart';
import '../../contracts/alienPuzzle/AlienPuzzleRewardItemType.dart';
import '../../contracts/alienPuzzle/alienPuzzleReward.dart';
import '../../contracts/requiredItem.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../contracts/techTree/techTree.dart';
import '../../helpers/itemsHelper.dart';
import '../../integration/dependencyInjection.dart';
import '../techTree/unlockableTechTreeComponents.dart';

class AlienPuzzlesRewardPage extends StatefulWidget {
  final List<AlienPuzzleReward> rewards;
  AlienPuzzlesRewardPage(this.rewards) {
    getAnalytics().trackEvent(AnalyticsEvent.alienPuzzlesRewardDetailPage);
  }

  @override
  _AlienPuzzlesRewardWidget createState() =>
      _AlienPuzzlesRewardWidget(this.rewards);
}

class _AlienPuzzlesRewardWidget<T> extends State<AlienPuzzlesRewardPage>
    with AfterLayoutMixin<AlienPuzzlesRewardPage> {
  final List<AlienPuzzleReward> baseRewards;
  List<AlienPuzzleRewardWithAdditional> _rewards = List.empty(growable: true);
  List<TechTree> _techTree = List.empty(growable: true);
  bool hasLoaded = false;
  bool hasFailed = false;

  _AlienPuzzlesRewardWidget(this.baseRewards);

  @override
  void afterFirstLayout(BuildContext context) {
    getList(context);
  }

  Future<Null> getList(BuildContext context) async {
    List<AlienPuzzleRewardWithAdditional> newRewards =
        List.empty(growable: true);
    List<TechTree> techTreesToDisplay = List.empty(growable: true);
    try {
      for (AlienPuzzleReward baseReward in baseRewards) {
        AlienPuzzleRewardWithAdditional newItem =
            AlienPuzzleRewardWithAdditional(baseReward);
        List<AlienPuzzleRewardOddsWithAdditional> detailRewards =
            List.empty(growable: true);
        if (baseReward.rewardId == 'RECIPE_LIST' ||
            baseReward.rewardId == 'USEFUL_PROD' ||
            baseReward.rewardId == 'FACT_PROD') {
          var rewardWithInfo =
              AlienPuzzleRewardOddsWithAdditional(AlienPuzzleRewardOdds(
            type: AlienPuzzleRewardItemType.Product,
            amountMin: 1,
            amountMax: 1,
          ));

          ResultWithValue<RequiredItemDetails> details =
              await requiredItemDetails(
            context,
            RequiredItem(
              id: 'cur44',
              quantity: 1,
            ),
          );
          if (details.isSuccess) {
            rewardWithInfo.details = details.value;
            rewardWithInfo.details.icon = AppImage.factoryOverride;
          }

          var subTreeId = '';
          if (baseReward.rewardId == 'RECIPE_LIST') {
            subTreeId = 'tree9-subTree1';
          }
          if (baseReward.rewardId == 'USEFUL_PROD' ||
              baseReward.rewardId == 'FACT_PROD') {
            subTreeId = 'tree9-subTree2';
          }

          if (subTreeId != '') {
            var subTechTree =
                await getTechTreeRepo().getSubTree(context, subTreeId);
            if (subTechTree.isSuccess) {
              techTreesToDisplay.add(subTechTree.value);
            }
          }
          detailRewards.add(rewardWithInfo);
        } else {
          for (AlienPuzzleRewardOdds reward in newItem.rewards) {
            AlienPuzzleRewardOddsWithAdditional newRewardItem =
                AlienPuzzleRewardOddsWithAdditional(reward);

            if (alienPuzzleRewardItemRequiresAdditionalData
                .contains(reward.type)) {
              ResultWithValue<RequiredItemDetails> details =
                  await requiredItemDetails(
                context,
                RequiredItem(
                  id: reward.id,
                  quantity: 1,
                ),
              );
              if (details.isSuccess) {
                newRewardItem.details = details.value;
              }
            }
            detailRewards.add(newRewardItem);
          }
        }
        newItem.details = detailRewards;
        newRewards.add(newItem);
      }
    } catch (exception) {}

    setState(() {
      hasLoaded = true;
      _rewards = newRewards;
      _techTree = techTreesToDisplay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return genericPageScaffold(
      context,
      getTranslations().fromKey(LocaleKey.puzzles),
      null, //unused
      body: getBody,
    );
  }

  Widget getBody(BuildContext context, unused) {
    if (this.hasFailed == true) return getLoading().customErrorWidget(context);
    if (this.hasLoaded == false) return getLoading().fullPageLoading(context);

    List<Widget> widgets = List.empty(growable: true);
    for (AlienPuzzleRewardWithAdditional reward in _rewards) {
      // widgets.add(Center(
      //     child: Padding(
      //   child: Text('reward'),
      //   padding: EdgeInsets.only(top: 8),
      // )));
      var orderedRewardDetails = reward.details.toList();
      orderedRewardDetails.sort(
        (a, b) => ((a.type.toString()).compareTo(b.type.toString())),
      );
      if (reward.rewardId.contains('PROC_') ||
          reward.rewardId.contains('SUBST_TECH') ||
          reward.rewardId.contains('SUBST_FUEL') ||
          reward.rewardId.contains('SUBST_COMMOD')) {
        widgets.add(
          alienPuzzleRewardExpandableOddsTilePresenter(context, reward),
        );
      } else {
        widgets.addAll(orderedRewardDetails
            .map((p) => alienPuzzleRewardOddsTilePresenter(context, p))
            .toList());
        // widgets.add(customDivider());
      }
    }
    if (widgets.length > 0) {
      widgets.add(customDivider());
    }
    for (var techTree in _techTree) {
      widgets.add(getSubTree(
        context,
        techTree,
        getTranslations().fromKey(
          LocaleKey.unlockItemsUsingTheFactoryOverrideUnit,
        ),
      ));
    }
    if (widgets.length < 1) {
      widgets.add(
        Container(
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

    widgets.add(emptySpace8x());

    return Column(
      children: [
        Expanded(
          child: listWithScrollbar(
            itemCount: widgets.length,
            itemBuilder: (context, index) => widgets[index],
          ),
        ),
      ],
    );
  }
}
