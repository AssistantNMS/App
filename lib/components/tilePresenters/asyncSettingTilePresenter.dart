// ignore_for_file: no_logic_in_create_state

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

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
    return flatCard(
      child: genericListTile(
        context,
        leadingImage: null,
        name: title,
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
        trailing: isLoading ? getLoading().smallLoadingIndicator() : Icon(icon),
      ),
    );
  }
}

Future<dynamic> asyncSettingTileWithSuccessFunc<T>(
    BuildContext context,
    Future<ResultWithValue<T>> Function() asyncFunc,
    LocaleKey errorMessage,
    Function(T) successFunc,
    LocaleKey successMessage) async {
  ResultWithValue<T> readResult = await asyncFunc();
  if (readResult.hasFailed) {
    getDialog().showSimpleDialog(
      context,
      getTranslations().fromKey(LocaleKey.error),
      Text(getTranslations().fromKey(errorMessage)),
      buttonBuilder: (BuildContext ctx) => [
        getDialog().simpleDialogCloseButton(ctx),
      ],
    );
  } else {
    successFunc(readResult.value);
    getDialog().showSimpleDialog(
      context,
      getTranslations().fromKey(LocaleKey.success),
      Text(getTranslations().fromKey(successMessage)),
      buttonBuilder: (BuildContext ctx) => [
        getDialog().simpleDialogCloseButton(ctx),
      ],
    );
  }
}

Future<dynamic> asyncSettingTileGenericFunc<T>(
    BuildContext context,
    Future<Result> Function() asyncFunc,
    LocaleKey errorMessage,
    LocaleKey successMessage) async {
  Result readResult = await asyncFunc();
  print(readResult.hasFailed);
  if (readResult.hasFailed) {
    getDialog().showSimpleDialog(
      context,
      getTranslations().fromKey(LocaleKey.error),
      Text(getTranslations().fromKey(errorMessage)),
      buttonBuilder: (BuildContext ctx) => [
        getDialog().simpleDialogCloseButton(ctx),
      ],
    );
  } else {
    getDialog().showSimpleDialog(
      context,
      getTranslations().fromKey(LocaleKey.success),
      Text(getTranslations().fromKey(successMessage)),
      buttonBuilder: (BuildContext ctx) => [
        getDialog().simpleDialogCloseButton(ctx),
      ],
    );
  }
}
