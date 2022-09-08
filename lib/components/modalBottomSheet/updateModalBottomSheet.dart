import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppDuration.dart';
import '../../constants/Modal.dart';
import '../../contracts/data/majorUpdateItem.dart';
import '../../integration/dependencyInjection.dart';
import '../../pages/newItemsInUpdate/majorUpdatesDetailPage.dart';

class UpdateBottomSheet extends StatelessWidget {
  const UpdateBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResultWithValue<MajorUpdateItem>>(
      future: getDataRepo().getLatestMajorUpdate(context),
      builder: (BuildContext context,
          AsyncSnapshot<ResultWithValue<MajorUpdateItem>> snapshot) {
        Widget errorWidget = asyncSnapshotHandler(
          context,
          snapshot,
          loader: getLoading().loadingIndicator,
        );
        if (errorWidget != null) return errorWidget;

        List<Widget Function()> widgets = [
          () => localImage(
                snapshot.data.value.icon,
                padding: const EdgeInsets.all(0),
                boxfit: BoxFit.fill,
              ),
          () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: positiveButton(
                  context,
                  title: getTranslations().fromKey(LocaleKey.viewItemsAdded),
                  onPress: () => getNavigation().navigateAsync(
                    context,
                    navigateTo: (context) => MajorUpdatesDetailPage(
                      updateNewItems: snapshot.data.value,
                    ),
                  ),
                ),
              ),
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
      },
    );
  }
}
