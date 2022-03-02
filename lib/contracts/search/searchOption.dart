import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

import 'searchOptionType.dart';

class SearchOption {
  LocaleKey title;
  String image;
  SearchOptionType type;
  bool hidden;
  String value;
  dynamic actualValue;

  SearchOption({
    this.title,
    this.image,
    this.type,
    this.hidden,
    this.value = '',
    this.actualValue,
  });
}
