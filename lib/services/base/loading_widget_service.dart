import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';
import '../../components/common/loading.dart';

class LoadingWidgetService implements ILoadingWidgetService {
  @override
  Widget smallLoadingIndicator() => const CustomSpinner();

  @override
  Widget smallLoadingTile(BuildContext context, {String? loadingText}) =>
      ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: smallLoadingIndicator(),
        ),
        title:
            Text(loadingText ?? getTranslations().fromKey(LocaleKey.loading)),
      );

  @override
  Widget loadingIndicator({double height = 50.0}) => Container(
        alignment: const Alignment(0, 0),
        child: smallLoadingIndicator(),
        height: height,
      );

  @override
  Widget fullPageLoading(BuildContext context, {String? loadingText}) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              smallLoadingIndicator(),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.all(12),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          Row(
            children: [
              Text(loadingText ?? getTranslations().fromKey(LocaleKey.loading))
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ],
      );

  @override
  Widget customErrorWidget(BuildContext context, {String? text}) {
    return Center(
      child: Column(
        children: [
          const LocalImage(
            imagePath: AppImage.error,
            width: 250,
            padding: EdgeInsets.all(8),
          ),
          Text(
            text ?? getTranslations().fromKey(LocaleKey.somethingWentWrong),
            style: const TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
