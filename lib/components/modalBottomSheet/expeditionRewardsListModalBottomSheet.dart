import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../constants/AppAnimation.dart';
import '../../constants/Modal.dart';

import '../../contracts/redux/appState.dart';
import '../../contracts/requiredItem.dart';
import '../../contracts/requiredItemDetails.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionReward.dart';
import '../../helpers/itemsHelper.dart';
import '../../redux/modules/expedition/expeditionViewModel.dart';
import '../tilePresenters/seasonalExpeditionRewardDetailsTilePresenter.dart';

class ExpeditionRewardsListModalBottomSheet extends StatefulWidget {
  final String milestoneId;
  final List<SeasonalExpeditionReward> rewards;
  const ExpeditionRewardsListModalBottomSheet(this.milestoneId, this.rewards,
      {Key key})
      : super(key: key);

  @override
  _ExpeditionRewardsListModalBottomSheetWidget createState() =>
      _ExpeditionRewardsListModalBottomSheetWidget();
}

class _ExpeditionRewardsListModalBottomSheetWidget
    extends State<ExpeditionRewardsListModalBottomSheet> {
  @override
  Widget build(BuildContext context) {
    getLog().i(widget.milestoneId);

    List<RequiredItem> requiredItems = widget.rewards //
        .map((r) => RequiredItem(id: r.id, quantity: 1))
        .toList();

    return AnimatedSize(
      duration: AppAnimation.modal,
      child: Container(
        constraints: modalDefaultSize(context),
        child: FutureBuilder(
          future: requiredItemDetailsFromInputs(
            context,
            requiredItems,
            failOnItemNotFound: false,
          ),
          builder: (BuildContext futureContext,
                  AsyncSnapshot<ResultWithValue<List<RequiredItemDetails>>>
                      snapshot) =>
              StoreConnector<AppState, ExpeditionViewModel>(
            converter: (store) => ExpeditionViewModel.fromStore(store),
            builder:
                (BuildContext storeContext, ExpeditionViewModel viewModel) {
              Widget errorWidget = asyncSnapshotHandler(
                futureContext,
                snapshot,
                loader: getLoading().loadingIndicator,
                isValidFunction:
                    (ResultWithValue<List<RequiredItemDetails>> result) {
                  if (result.hasFailed) return false;
                  if (result.value.length != requiredItems.length) return false;

                  return true;
                },
              );
              if (errorWidget != null) return errorWidget;

              List<RequiredItemDetails> rewardLookups = snapshot.data.value;
              List<Widget Function()> widgetFuncs = widget.rewards
                  .map(
                    (r) => () => seasonalExpeditionRewardDetailTilePresenter(
                        futureContext, r, rewardLookups),
                  )
                  .toList();

              if (widget.milestoneId != null && widget.milestoneId.isNotEmpty) {
                widgetFuncs.add(() => emptySpace1x());
                bool isClaimed = false;
                if (viewModel.claimedRewards
                    .any((cla) => cla == widget.milestoneId)) {
                  isClaimed = true;
                }
                if (isClaimed) {
                  widgetFuncs.add(
                    () => negativeButton(
                      title:
                          getTranslations().fromKey(LocaleKey.markAsNotClaimed),
                      onPress: () => viewModel
                          .removeFromClaimedRewards(widget.milestoneId),
                    ),
                  );
                } else {
                  widgetFuncs.add(
                    () => positiveButton(
                      context,
                      title: getTranslations().fromKey(LocaleKey.markAsClaimed),
                      onPress: () =>
                          viewModel.addToClaimedRewards(widget.milestoneId),
                    ),
                  );
                }
              }

              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 20, left: 0, right: 0, bottom: 32),
                itemCount: widgetFuncs.length,
                itemBuilder: (_, int index) => widgetFuncs[index](),
                shrinkWrap: true,
              );
            },
          ),
        ),
      ),
    );
  }
}
