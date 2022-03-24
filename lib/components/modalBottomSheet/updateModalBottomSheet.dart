import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppDuration.dart';
import '../../constants/Modal.dart';
import '../../contracts/data/updateItemDetail.dart';
import '../../integration/dependencyInjection.dart';
import '../../pages/newItemsInUpdate/newItemDetailsPage.dart';

class UpdateBottomSheet extends StatefulWidget {
  final String updateImagePath;
  final String newItemGuid;
  const UpdateBottomSheet(this.updateImagePath, this.newItemGuid, {Key key})
      : super(key: key);

  @override
  _UpdateBottomSheetWidget createState() =>
      // ignore: no_logic_in_create_state
      _UpdateBottomSheetWidget(updateImagePath, newItemGuid);
}

class _UpdateBottomSheetWidget extends State<UpdateBottomSheet> {
  final String updateImagePath;
  final String newItemGuid;

  _UpdateBottomSheetWidget(this.updateImagePath, this.newItemGuid);

  @override
  Widget build(BuildContext context) {
    List<Widget Function()> widgets = [
      () => localImage(
            updateImagePath,
            padding: const EdgeInsets.all(0),
            boxfit: BoxFit.fill,
          ),
      () => FutureBuilder<ResultWithValue<UpdateItemDetail>>(
          future: getDataRepo().getUpdateItem(context, newItemGuid),
          builder: (BuildContext context,
              AsyncSnapshot<ResultWithValue<UpdateItemDetail>> snapshot) {
            Widget errorWidget = asyncSnapshotHandler(
              context,
              snapshot,
              loader: getLoading().loadingIndicator,
            );
            if (errorWidget != null) return errorWidget;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: positiveButton(
                context,
                title: getTranslations().fromKey(LocaleKey.viewItemsAdded),
                onPress: () => getNavigation().navigateAsync(
                  context,
                  navigateTo: (context) =>
                      NewItemsDetailPage(snapshot.data.value),
                ),
              ),
            );
          })
    ];

    return AnimatedSize(
      duration: AppDuration.modal,
      child: Container(
        constraints: modalDefaultSize(context),
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: widgets.length,
          itemBuilder: (_, int index) => widgets[index](),
          shrinkWrap: true,
        ),
      ),
    );
  }
}
