List<String> intArrayToHexArray(List<int> currentCodes) {
  List<String> hexCodes = List.empty(growable: true);
  for (var code in currentCodes) {
    hexCodes.add(code.toRadixString(16));
  }
  return hexCodes;
}

String intArrayToHex(List<int> currentCodes) {
  String hexCodes = '';
  for (var code in currentCodes) {
    hexCodes += code.toRadixString(16);
  }
  return hexCodes;
}

List<int> hexToIntArray(String code) => code //
    .split('')
    .map((hex) => int.tryParse(hex, radix: 16) ?? 0)
    .toList();

String allUpperCase(String input) {
  String result = '';
  for (var hexIndex = 0; hexIndex < input.length; hexIndex++) {
    result += input[hexIndex].toUpperCase();
  }
  return result;
}
