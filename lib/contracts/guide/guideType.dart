import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

enum GuideType {
  Text,
  Image,
  Link,
  Markdown,
  Table,
}

final guideTypeValues = EnumValues({
  "text": GuideType.Text,
  "image": GuideType.Image,
  "link": GuideType.Link,
  "markdown": GuideType.Markdown,
  "table": GuideType.Table,
});
