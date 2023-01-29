import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/integration/dependencyInjection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/modalBottomSheet/patreon_modal_bottom_sheet.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/majorUpdateTilePresenter.dart';
import '../../constants/Patreon.dart';
import '../../contracts/data/majorUpdateItem.dart';
import '../../contracts/redux/appState.dart';
import '../../redux/modules/setting/isPatreonViewModel.dart';
import 'majorUpdatesSpeculationPage.dart';

class MajorUpdatesPage extends StatelessWidget {
  const MajorUpdatesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.newItemsAdded),
      body: StoreConnector<AppState, IsPatreonViewModel>(
        converter: (store) => IsPatreonViewModel.fromStore(store),
        builder: (_, viewModel) {
          return FutureBuilder<ResultWithValue<List<MajorUpdateItem>>>(
            future: getDataRepo().getMajorUpdates(context),
            builder: (bodyCtx, asyncSnapshot) =>
                getBodyFromFuture(bodyCtx, asyncSnapshot, viewModel),
          );
        },
      ),
    );
  }

  Widget getBodyFromFuture(
    BuildContext bodyCtx,
    AsyncSnapshot<ResultWithValue<List<MajorUpdateItem>>> snapshot,
    IsPatreonViewModel reduxViewModel,
  ) {
    List<Widget> listItems = List.empty(growable: true);

    Widget? errorWidget = asyncSnapshotHandler(
      bodyCtx,
      snapshot,
      loader: () => getLoading().fullPageLoading(bodyCtx),
      isValidFunction: (ResultWithValue<List<MajorUpdateItem>>? expResult) {
        if (expResult?.hasFailed ?? true) return false;
        if (expResult?.value == null) return false;
        return true;
      },
    );
    if (errorWidget != null) return errorWidget;

    listItems.add(majorUpdateTilePresenter(
      bodyCtx,
      MajorUpdateItem(
        guid: getNewGuid(),
        gameVersion: getTranslations().fromKey(LocaleKey.speculation),
        title: getTranslations().fromKey(LocaleKey.speculation),
        icon: 'update/speculation.png',
        itemIds: [],
        updateType: UpdateType.minor,
        releaseDate: DateTime.now(),
      ),
      isPatronLocked: isPatreonFeatureLocked(
        PatreonEarlyAccessFeature.newMajorUpdatesPage,
        reduxViewModel.isPatron,
      ),
      onTap: () {
        handlePatreonBottomModalSheetWhenTapped(
          bodyCtx,
          reduxViewModel.isPatron,
          unlockDate: PatreonEarlyAccessFeature.newMajorUpdatesPage,
          onTap: (dialogCtx) => getNavigation().navigateAwayFromHomeAsync(
            dialogCtx,
            navigateTo: (_) =>
                MajorUpdatesSpeculationPage(items: snapshot.data!.value),
          ),
        );
      },
    ));
    for (MajorUpdateItem update in snapshot.data!.value) {
      listItems.add(majorUpdateTilePresenter(bodyCtx, update));
    }

    return listWithScrollbar(
      shrinkWrap: true,
      itemCount: listItems.length,
      itemBuilder: (BuildContext context, int index) => listItems[index],
      padding: const EdgeInsets.only(bottom: 64),
      scrollController: ScrollController(),
    );
  }
}
