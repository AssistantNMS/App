import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'searchOptionType.dart';

class SearchOption {
  LocaleKey title;
  String image;
  SearchOptionType type;
  bool hidden;
  String? value;
  dynamic actualValue;

  SearchOption({
    required this.title,
    required this.image,
    required this.type,
    this.hidden = false,
    this.value = '',
    this.actualValue,
  });
}
