import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../contracts/data/major_update_item.dart';
import '../../contracts/generic_page_item.dart';
import '../../helpers/future_helper.dart';
import '../../helpers/generic_helper.dart';
import '../../helpers/repository_helper.dart';

class MajorUpdatesDetailPage extends StatelessWidget {
  final MajorUpdateItem updateNewItems;
  const MajorUpdatesDetailPage({
    Key? key,
    required this.updateNewItems,
  }) : super(key: key);

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
    Widget Function(BuildContext, GenericPageItem, {void Function()? onTap})
        presenter = getListItemDisplayer(
      true,
      true,
      isHero: true,
    );

    Widget? errorWidget = asyncSnapshotHandler(
      bodyCtx,
      snapshot,
      loader: () => getLoading().fullPageLoading(bodyCtx),
      isValidFunction: (ResultWithValue<List<GenericPageItem>>? expResult) {
        if (expResult?.hasFailed ?? false) return false;
        if (expResult?.value == null) return false;
        return true;
      },
    );
    if (errorWidget != null) return errorWidget;

    List<GenericPageItem> localUpdateNewItems = snapshot.data!.value;
    List<Widget> listItems = List.empty(growable: true);

    listItems.add(const EmptySpace2x());
    listItems.add(Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
        child: LocalImage(imagePath: localMajorItem.icon, width: 200),
      ),
    ));

    listItems.add(const EmptySpace1x());
    if (localMajorItem.emoji != null && localMajorItem.emoji!.isNotEmpty) {
      listItems.add(Center(
        child: Text(
          localMajorItem.emoji!,
          style: const TextStyle(fontSize: 30),
        ),
      ));
      listItems.add(const EmptySpace1x());
    }
    listItems.add(Center(
      child: GenericItemName(simpleDate(localMajorItem.releaseDate)),
    ));
    if (localUpdateNewItems.isNotEmpty) {
      listItems.add(const EmptySpace1x());
      listItems.add(Center(
        child: Text(getTranslations().fromKey(LocaleKey.newItemsAdded) +
            ': ' +
            localUpdateNewItems.length.toString()),
      ));
      listItems.add(const EmptySpace1x());
    }
    if (localMajorItem.postUrl != null && localMajorItem.postUrl!.isNotEmpty) {
      listItems.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: PositiveButton(
          title: getTranslations().fromKey(LocaleKey.viewPostOnline),
          onTap: () => launchExternalURL(localMajorItem.postUrl!),
        ),
      ));
    }
    listItems.add(customDivider());
    listItems.add(const EmptySpace1x());

    if (localUpdateNewItems.isNotEmpty) {
      for (GenericPageItem gItem in localUpdateNewItems) {
        listItems.add(presenter(bodyCtx, gItem));
      }
    } else {
      listItems.add(Center(
        child: GenericItemGroup(
          getTranslations().fromKey(LocaleKey.noItemsRecorded),
        ),
      ));
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
