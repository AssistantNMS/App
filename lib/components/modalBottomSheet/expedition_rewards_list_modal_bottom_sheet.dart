import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../constants/app_duration.dart';
import '../../constants/modal.dart';
import '../../contracts/redux/app_state.dart';
import '../../contracts/required_item.dart';
import '../../contracts/required_item_details.dart';
import '../../contracts/seasonalExpedition/seasonal_expedition_reward.dart';
import '../../helpers/items_helper.dart';
import '../../redux/modules/expedition/expedition_view_model.dart';
import '../tilePresenters/seasonal_expedition_reward_details_tile_presenter.dart';

class ExpeditionRewardsListModalBottomSheet extends StatefulWidget {
  final String milestoneId;
  final List<SeasonalExpeditionReward> rewards;
  const ExpeditionRewardsListModalBottomSheet(this.milestoneId, this.rewards,
      {Key? key})
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
        Widget? errorWidget = asyncSnapshotHandler(
          futureContext,
          snapshot,
          loader: getLoading().loadingIndicator,
          isValidFunction:
              (ResultWithValue<List<RequiredItemDetails>>? result) {
            return result?.isSuccess ?? false;
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
    ResultWithValue<List<RequiredItemDetails>>? snapshot,
  ) {
    List<RequiredItemDetails>? rewardLookups = snapshot?.value;
    List<Widget Function()> widgetFuncs = widget.rewards
        .map((reward) => () => seasonalExpeditionRewardDetailTilePresenter(
              futureContext,
              reward,
              rewardLookups ?? List.empty(),
            ))
        .toList();

    if (widget.milestoneId.isNotEmpty) {
      widgetFuncs.add(() => const EmptySpace1x());
      bool isClaimed = false;
      if (viewModel.claimedRewards.any((cla) => cla == widget.milestoneId)) {
        isClaimed = true;
      }

      Widget button = NegativeButton(
        title: getTranslations().fromKey(LocaleKey.markAsNotClaimed),
        onTap: () => viewModel.removeFromClaimedRewards(widget.milestoneId),
      );
      if (!isClaimed) {
        button = PositiveButton(
          title: getTranslations().fromKey(LocaleKey.markAsClaimed),
          onTap: () => viewModel.addToClaimedRewards(widget.milestoneId),
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
