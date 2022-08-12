import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../constants/AppDuration.dart';
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
      duration: AppDuration.modal,
      child: Container(
        constraints: modalDefaultSize(context),
        child: FutureBuilder(
          future: requiredItemDetailsFromInputs(
            context,
            requiredItems,
            failOnItemNotFound: false,
          ),
          builder: modalReduxWrapper,
        ),
      ),
    );
  }

  Widget modalReduxWrapper(
    BuildContext futureContext,
    AsyncSnapshot<ResultWithValue<List<RequiredItemDetails>>> snapshot,
  ) {
    return StoreConnector<AppState, ExpeditionViewModel>(
      converter: (store) => ExpeditionViewModel.fromStore(store),
      builder: (BuildContext storeContext, ExpeditionViewModel viewModel) {
        Widget errorWidget = asyncSnapshotHandler(
          futureContext,
          snapshot,
          loader: getLoading().loadingIndicator,
          isValidFunction: (ResultWithValue<List<RequiredItemDetails>> result) {
            return result.isSuccess;
          },
        );
        if (errorWidget != null) return errorWidget;

        return modalBody(futureContext, viewModel, snapshot.data);
      },
    );
  }

  Widget modalBody(
    BuildContext futureContext,
    ExpeditionViewModel viewModel,
    ResultWithValue<List<RequiredItemDetails>> snapshot,
  ) {
    List<RequiredItemDetails> rewardLookups = snapshot.value;
    List<Widget Function()> widgetFuncs = widget.rewards
        .map((reward) => () => seasonalExpeditionRewardDetailTilePresenter(
              futureContext,
              reward,
              rewardLookups,
            ))
        .toList();

    if (widget.milestoneId != null && widget.milestoneId.isNotEmpty) {
      widgetFuncs.add(() => emptySpace1x());
      bool isClaimed = false;
      if (viewModel.claimedRewards.any((cla) => cla == widget.milestoneId)) {
        isClaimed = true;
      }

      Widget button = negativeButton(
        title: getTranslations().fromKey(LocaleKey.markAsNotClaimed),
        onPress: () => viewModel.removeFromClaimedRewards(widget.milestoneId),
      );
      if (!isClaimed) {
        button = positiveButton(
          context,
          title: getTranslations().fromKey(LocaleKey.markAsClaimed),
          onPress: () => viewModel.addToClaimedRewards(widget.milestoneId),
        );
      }

      widgetFuncs.add(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: button,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 14,
        left: 0,
        right: 0,
        bottom: 32,
      ),
      itemCount: widgetFuncs.length,
      itemBuilder: (_, int index) => widgetFuncs[index](),
      shrinkWrap: true,
    );
  }
}
