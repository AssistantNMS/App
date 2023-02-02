import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/generic_page_scaffold.dart';
import '../../components/tilePresenters/friend_code_tile_presenter.dart';
import '../../constants/analytics_event.dart';
import '../../contracts/generated/friend_code_view_model.dart';
import '../../integration/dependency_injection.dart';
import 'add_friend_code_page.dart';

const String pc = 'PC';
const String ps4 = 'PS';
const String xb1 = 'XB';
const String nsw = 'SW';

class FriendCodeListPage extends StatefulWidget {
  const FriendCodeListPage({Key? key}) : super(key: key);

  @override
  _FriendCodeListWidget createState() => _FriendCodeListWidget();
}

class _FriendCodeListWidget extends State<FriendCodeListPage> {
  List<String> currentSelection = [pc, ps4, xb1, nsw];
  List<String> allItemList = [pc, ps4, xb1, nsw];
  List<String> disabledItemList = [];

  _FriendCodeListWidget() {
    getAnalytics().trackEvent(AnalyticsEvent.friendCodeListPage);
  }

  @override
  Widget build(BuildContext context) {
    bool showPC = currentSelection.contains(pc);
    bool showPS4 = currentSelection.contains(ps4);
    bool showXb1 = currentSelection.contains(xb1);
    bool showNsw = currentSelection.contains(nsw);
    return basicGenericPageScaffold<dynamic>(
      context,
      title: getTranslations().fromKey(LocaleKey.friendCodes),
      body: SearchableList<FriendCodeViewModel>(
        () => getApiRepo().getFriendCodes(showPC, showPS4, showXb1, showNsw),
        listItemDisplayer:
            (BuildContext context, FriendCodeViewModel friendCode,
                    {void Function()? onTap}) =>
                friendCodeTilePresenter(context, context, friendCode),
        listItemSearch: (FriendCodeViewModel option, String search) =>
            option.name.toLowerCase().contains(search.toLowerCase()),
        minListForSearch: 0,
        addFabPadding: true,
        keepFirstListItemWidgetVisible: true,
        firstListItemWidget: Column(
          children: [
            AdaptiveCheckboxGroup(
              allItemList: allItemList,
              selectedItems: currentSelection,
              disabledItems: disabledItemList,
              onChanged: (itemList) => setState(() {
                currentSelection = itemList;
              }),
            ),
            getBaseWidget().customDivider(),
          ],
        ),
        key: Key('firendCodes-${currentSelection.length}'),
      ),
      fab: FloatingActionButton(
        onPressed: () => getNavigation().navigateAsync(
          context,
          navigateTo: (context) => const AddFriendCodePage(),
        ),
        heroTag: 'AddFriendCodePage',
        child: const Icon(Icons.add),
        foregroundColor: getTheme().fabForegroundColourSelector(context),
        backgroundColor: getTheme().fabColourSelector(context),
      ),
    );
  }
}
