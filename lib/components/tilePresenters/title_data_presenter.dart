// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/title_data_with_owned.dart';
import '../../helpers/currency_helper.dart';
import '../../redux/modules/titles/title_view_model.dart';

Widget Function(BuildContext, TitleDataWithOwned, {void Function()? onTap})
    titleDataTilePresenter(TitleViewModel viewModel) =>
        (BuildContext context, TitleDataWithOwned titleData,
            {void Function()? onTap}) {
          return TitleDataTile(
            viewModel,
            titleData,
            key: Key(titleData.id),
          );
        };

class TitleDataTile extends StatefulWidget {
  final TitleViewModel viewModel;
  final TitleDataWithOwned titleData;
  const TitleDataTile(this.viewModel, this.titleData, {Key? key})
      : super(key: key);

  @override
  _TitleDataTileState createState() => _TitleDataTileState(
        viewModel,
        titleData,
      );
}

class _TitleDataTileState extends State<TitleDataTile> {
  final TitleViewModel viewModel;
  final TitleDataWithOwned titleData;

  _TitleDataTileState(this.viewModel, this.titleData);

  void setOwned(bool newIsOwned, void Function() callback) {
    setState(() {
      titleData.isOwned = newIsOwned;
    });
    callback();
  }

  @override
  Widget build(BuildContext context) {
    Function() viewModelFunc = titleData.isOwned
        ? () => viewModel.removeFromOwned(titleData.id)
        : () => viewModel.addToOwned(titleData.id);
    Function() toggleOwned;
    toggleOwned = () => setOwned(!titleData.isOwned, viewModelFunc);

    return ListTile(
      leading: (titleData.appIcon.length > 5)
          ? LocalImage(
              imagePath:
                  '${getPath().imageAssetPathPrefix}/${titleData.appIcon}',
            )
          : null,
      title: Text(
        titleData.title.replaceAll(
          "{0}",
          viewModel.playerTitle ?? 'YourNameHere',
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        titleData.description.replaceAll(
            "%NUM%",
            currencyFormat(
              titleData.unlockedByStatValue.toString(),
              addDecimal: false,
            )),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: getBaseWidget().adaptiveCheckbox(
        value: titleData.isOwned,
        onChanged: (_) => toggleOwned(),
      ),
      onTap: toggleOwned,
    );
  }
}
