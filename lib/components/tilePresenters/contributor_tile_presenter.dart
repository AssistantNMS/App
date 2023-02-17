import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/generated/contributor_view_model.dart';

Widget contributorTilePresenter(
  BuildContext context,
  ContributorViewModel contributor, {
  void Function()? onTap,
}) =>
    genericListTileWithNetworkImage(
      context,
      imageUrl: contributor.imageUrl,
      name: contributor.name,
      subtitle: Text(
        contributor.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => launchExternalURL(contributor.link),
    );
