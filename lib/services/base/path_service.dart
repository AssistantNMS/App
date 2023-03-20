import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_image.dart';

class PathService implements IPathService {
  final String imageAssetPath;

  PathService({
    this.imageAssetPath = 'assets/images',
  });

  @override
  String get imageAssetPathPrefix => imageAssetPath;

  @override
  Widget get steamNewsDefaultImage => LocalImage(
        imagePath: '$imageAssetPath/defaultSteamNews.jpg',
        imagePackage: UIConstants.commonPackage,
      );

  @override
  String get defaultProfilePic => '';
  @override
  String get unknownImagePath => AppImage.unknown;

  @override
  String get defaultGuideImage => AppImage.guide;

  @override
  String ofImage(String imagePartialPath) {
    if (imagePartialPath.contains(imageAssetPath)) {
      return imagePartialPath;
    }

    return '$imageAssetPath/$imagePartialPath';
  }
}
