String currencyFormat(String numberString, {bool addDecimal = true}) {
  String result = '';
  String tempResult = '';

  String tempDecimalNumberString = '.0';
  String tempNumberString = numberString;
  int decimalIndex = numberString.indexOf('.');
  if (decimalIndex > 0) {
    tempNumberString = numberString.substring(0, decimalIndex);
    tempDecimalNumberString =
        numberString.substring(decimalIndex, numberString.length);
  }

  for (int index = 0; index < tempNumberString.length; index++) {
    if (index % 3 == 0 && index > 0) {
      // tempResult = tempResult + ',';
      tempResult = tempResult + ' ';
    }
    tempResult =
        tempResult + tempNumberString[tempNumberString.length - (index + 1)];
  }
  for (int index = 0; index < tempResult.length; index++) {
    result = result + tempResult[tempResult.length - (index + 1)];
  }
  if (addDecimal) {
    result += tempDecimalNumberString;
  }

  return result;
}
