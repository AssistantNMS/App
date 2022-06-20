import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../contracts/data/majorUpdateItem.dart';
import '../../contracts/genericPageItem.dart';
import '../../helpers/futureHelper.dart';
import '../../helpers/genericHelper.dart';
import '../../helpers/repositoryHelper.dart';

class MajorUpdatesDetailPage extends StatelessWidget {
  final MajorUpdateItem updateNewItems;
  const MajorUpdatesDetailPage({Key key, this.updateNewItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return basicGenericPageScaffold(
      context,
      title: updateNewItems.gameVersion,
      body: FutureBuilder(
        future: getUpdateNewItemsDetailsList(
          context,
          updateNewItems.itemIds,
          getAllItemsLocaleKeys,
        ),
        builder: (
          BuildContext ctx,
          AsyncSnapshot<ResultWithValue<List<GenericPageItem>>> snapshot,
        ) =>
            getBodyFromFuture(ctx, snapshot, updateNewItems),
      ),
    );
  }

  Widget getBodyFromFuture(
    BuildContext bodyCtx,
    AsyncSnapshot<ResultWithValue<List<GenericPageItem>>> snapshot,
    MajorUpdateItem localMajorItem,
  ) {
    Widget Function(BuildContext, GenericPageItem, {void Function() onTap})
        presenter = getListItemDisplayer(
      true,
      true,
      isHero: true,
    );

    Widget errorWidget = asyncSnapshotHandler(
      bodyCtx,
      snapshot,
      loader: () => getLoading().fullPageLoading(bodyCtx),
      isValidFunction: (ResultWithValue<List<GenericPageItem>> expResult) {
        if (expResult.hasFailed) return false;
        if (expResult.value == null) return false;
        return true;
      },
    );
    if (errorWidget != null) return errorWidget;

    List<GenericPageItem> localUpdateNewItems = snapshot.data.value;
    List<Widget> listItems = List.empty(growable: true);

    listItems.add(emptySpace2x());
    listItems.add(Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
        child: localImage(localMajorItem.icon, width: 200),
      ),
    ));

    listItems.add(emptySpace1x());
    if (localMajorItem.emoji.isNotEmpty) {
      listItems.add(Center(
        child: Text(
          localMajorItem.emoji,
          style: const TextStyle(fontSize: 30),
        ),
      ));
      listItems.add(emptySpace1x());
    }
    listItems.add(Center(
      child: genericItemName(simpleDate(localMajorItem.releaseDate)),
    ));
    if (localUpdateNewItems.isNotEmpty) {
      listItems.add(emptySpace1x());
      listItems.add(Center(
        child: Text(getTranslations().fromKey(LocaleKey.newItemsAdded) +
            ': ' +
            localUpdateNewItems.length.toString()),
      ));
      listItems.add(emptySpace1x());
    }
    if (localMajorItem.postUrl.isNotEmpty) {
      listItems.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: positiveButton(
          bodyCtx,
          title: getTranslations().fromKey(LocaleKey.viewPostOnline),
          onPress: () => launchExternalURL(localMajorItem.postUrl),
        ),
      ));
    }
    listItems.add(customDivider());
    listItems.add(emptySpace1x());

    if (localUpdateNewItems.isNotEmpty) {
      for (GenericPageItem gItem in localUpdateNewItems) {
        listItems.add(presenter(bodyCtx, gItem));
      }
    } else {
      listItems.add(Center(
        child: genericItemGroup(
          getTranslations().fromKey(LocaleKey.noItemsRecorded),
        ),
      ));
    }

    return listWithScrollbar(
      shrinkWrap: true,
      itemCount: listItems.length,
      itemBuilder: (BuildContext context, int index) => listItems[index],
      padding: const EdgeInsets.only(bottom: 64),
    );
  }
}
