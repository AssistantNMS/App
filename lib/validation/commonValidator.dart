import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

bool nameValidator(String name, {int minLength = 1}) {
  if (name == null || name.length < minLength) {
    getLog().v('nameValidator: $name failed');
    return false;
  }
  return true;
}

bool emailValidator(String email) {
  String regexPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  var emailValid = RegExp(regexPattern).hasMatch(email);
  if (emailValid == false) getLog().v('emailValidator: $email failed');
  return emailValid;
}

bool friendCodeValidator(String friendCode) {
  String regexPattern = r"^[A-z0-9]{4}\-[A-z0-9]{4}\-[A-z0-9]{5}";
  var friendCodeValid = RegExp(regexPattern).hasMatch(friendCode);
  if (friendCodeValid == false) {
    getLog().v('friendCodeValidator: $friendCode failed');
  }
  return friendCodeValid;
}
