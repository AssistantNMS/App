// ignore_for_file: constant_identifier_names

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

enum NmsGuideType {
  Text,
  Image,
  Link,
  Markdown,
  Table,
}

final guideTypeValues = EnumValues({
  "text": NmsGuideType.Text,
  "image": NmsGuideType.Image,
  "link": NmsGuideType.Link,
  "markdown": NmsGuideType.Markdown,
  "table": NmsGuideType.Table,
});
