import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../integration/dependencyInjection.dart';

import '../../components/responsiveGridView.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';

class UnusedPatchImagesPage extends StatelessWidget {
  const UnusedPatchImagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.unusedMilestonePatches),
      body: FutureBuilder<ResultWithValue<List<String>>>(
        future: getDataRepo().getUnusedMileStonePatchImages(context),
        builder: (BuildContext futureContext, snapshot) {
          Widget? errorWidget = asyncSnapshotHandler(futureContext, snapshot);
          if (errorWidget != null) {
            return errorWidget;
          }
          return responsiveGrid(
            context,
            snapshot.data!.value,
            (BuildContext localContext, String path) {
              return Card(
                child: GestureDetector(
                  child: localImage(path),
                  onTap: () => getNavigation().navigateAsync(
                    context,
                    navigateTo: (context) => ImageViewerPage(
                      path.replaceAll('milestonePatches/', ''),
                      path,
                      analyticsKey: '',
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
