import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/cupertino.dart';

import '../../constants/AppImage.dart';

class PathService implements IPathService {
  String get imageAssetPathPrefix => 'assets/images';
  Widget get steamNewsDefaultImage => localImage(
        '$imageAssetPathPrefix/defaultSteamNews.jpg',
        imagePackage: UIConstants.CommonPackage,
      );
  String get defaultProfilePic => '';
  String get unknownImagePath => AppImage.unknown;
}
