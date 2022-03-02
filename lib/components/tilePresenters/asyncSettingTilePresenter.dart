// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/dialogs/baseDialog.dart';

class AsyncSettingTilePresenter extends StatefulWidget {
  final String title;
  final IconData icon;
  final Future Function() futureFunc;
  const AsyncSettingTilePresenter(
      {Key key,
      @required this.title,
      @required this.icon,
      @required this.futureFunc})
      : super(key: key);

  @override
  _AsyncSettingTilePresenterWidget createState() =>
      _AsyncSettingTilePresenterWidget(title, icon, futureFunc);
}

class _AsyncSettingTilePresenterWidget
    extends State<AsyncSettingTilePresenter> {
  final String title;
  final IconData icon;
  final Future Function() futureFunc;
  bool isLoading = false;
  _AsyncSettingTilePresenterWidget(this.title, this.icon, this.futureFunc);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: genericListTile(context, leadingImage: null, name: title,
          onTap: () async {
        if (futureFunc != null) {
          setState(() {
            isLoading = true;
          });
          try {
            await futureFunc();
          } catch (exception) {
            // unused
          } finally {
            setState(() {
              isLoading = false;
            });
          }
        }
      },
          trailing:
              isLoading ? getLoading().smallLoadingIndicator() : Icon(icon)),
      margin: const EdgeInsets.all(0.0),
    );
  }
}

Future<dynamic> asyncSettingTileWithSuccessFunc<T>(
    BuildContext context,
    Future<ResultWithValue<T>> Function() asyncFunc,
    LocaleKey errorMessage,
    Function(T) successFunc,
    LocaleKey successMessage) async {
  var readResult = await asyncFunc();
  if (readResult.hasFailed) {
    simpleDialog(
      context,
      getTranslations().fromKey(LocaleKey.error),
      getTranslations().fromKey(errorMessage),
      buttons: [simpleDialogCloseButton(context)],
    );
  } else {
    successFunc(readResult.value);
    simpleDialog(
      context,
      getTranslations().fromKey(LocaleKey.success),
      getTranslations().fromKey(successMessage),
      buttons: [simpleDialogCloseButton(context)],
    );
  }
}

Future<dynamic> asyncSettingTileGenericFunc<T>(
    BuildContext context,
    Future<Result> Function() asyncFunc,
    LocaleKey errorMessage,
    LocaleKey successMessage) async {
  var readResult = await asyncFunc();
  if (readResult.hasFailed) {
    simpleDialog(
      context,
      getTranslations().fromKey(LocaleKey.error),
      getTranslations().fromKey(errorMessage),
      buttons: [simpleDialogCloseButton(context)],
    );
  } else {
    simpleDialog(
      context,
      getTranslations().fromKey(LocaleKey.success),
      getTranslations().fromKey(successMessage),
      buttons: [simpleDialogCloseButton(context)],
    );
  }
}
