import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/AppImage.dart';

class PathService implements IPathService {
  @override
  String get imageAssetPathPrefix => 'assets/images';
  @override
  Widget get steamNewsDefaultImage => LocalImage(
        imagePath: '$imageAssetPathPrefix/defaultSteamNews.jpg',
        imagePackage: UIConstants.commonPackage,
      );
  @override
  String get defaultProfilePic => '';
  @override
  String get unknownImagePath => AppImage.unknown;

  @override
  String get defaultGuideImage => AppImage.guide;
}
