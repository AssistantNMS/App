import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_duration.dart';
import '../../constants/modal.dart';
import '../../contracts/data/major_update_item.dart';
import '../../integration/dependency_injection.dart';
import '../../pages/newItemsInUpdate/major_updates_detail_page.dart';

class UpdateBottomSheet extends StatelessWidget {
  const UpdateBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResultWithValue<MajorUpdateItem>>(
      future: getDataRepo().getLatestMajorUpdate(context),
      builder: (BuildContext context,
          AsyncSnapshot<ResultWithValue<MajorUpdateItem>> snapshot) {
        Widget? errorWidget = asyncSnapshotHandler(
          context,
          snapshot,
          loader: getLoading().loadingIndicator,
        );
        if (errorWidget != null) return errorWidget;

        ResultWithValue<MajorUpdateItem> result = snapshot.data!;

        List<Widget Function()> widgets = [
          () => LocalImage(
                imagePath: result.value.icon,
                padding: const EdgeInsets.all(0),
                boxfit: BoxFit.fill,
              ),
          () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: PositiveButton(
                  title: getTranslations().fromKey(LocaleKey.viewItemsAdded),
                  onTap: () => getNavigation().navigateAsync(
                    context,
                    navigateTo: (context) => MajorUpdatesDetailPage(
                      updateNewItems: result.value,
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
