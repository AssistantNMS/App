import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SnackbarService implements ISnackbarService {
  @override
  void showSnackbar(
    BuildContext context,
    LocaleKey lang, {
    String? description,
    Duration? duration,
    void Function()? onPositive,
    String? onPositiveText,
    IconData? onPositiveIcon,
    void Function()? onNegative,
  }) {
    // SnackBar snackBar = SnackBar(
    //   elevation: 0,
    //   behavior: SnackBarBehavior.floating,
    //   backgroundColor: Colors.transparent,
    //   duration: const Duration(seconds: 10),
    //   content: AwesomeSnackbarContent(
    //     title: getTranslations().fromKey(lang),
    //     message: description ?? '',
    //     contentType: ContentType.success,
    //     color: getTheme().getPrimaryColour(context),
    //   ),
    //   action: (onPositiveText != null)
    //       ? SnackBarAction(
    //           label: onPositiveText,
    //           onPressed: onNegative ?? () => getNavigation().pop(context),
    //         )
    //       : null,
    // );

    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
