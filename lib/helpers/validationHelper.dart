import 'package:flutter/material.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

OutlineInputBorder getTextFieldValidationBorderColour(
    BuildContext context, bool Function() validator, bool showValidation) {
  bool isValid = true;
  if (showValidation && validator != null) {
    isValid = validator();
  }
  return OutlineInputBorder(
    borderSide: BorderSide(
      color: isValid ? getTheme().getSecondaryColour(context) : Colors.red,
    ),
  );
}

InputDecoration getTextFieldDecoration(BuildContext context, LocaleKey locale,
    bool Function() validator, bool showValidation) {
  return InputDecoration(
    border: OutlineInputBorder(),
    enabledBorder: getTextFieldValidationBorderColour(
      context,
      validator,
      showValidation,
    ),
    focusedBorder: getTextFieldValidationBorderColour(
      context,
      validator,
      true,
    ),
    labelText: getTranslations().fromKey(locale),
  );
}
