import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../contracts/nmsfm/nmsfm_track_data.dart';

Widget nmsfmTrackTilePresenter(BuildContext context, NmsfmTrackData track,
    {void Function()? onTap}) {
  bool hasArtist = track.artist != null && track.artist!.isNotEmpty;
  bool hasTime = track.runtimeInSeconds != null && //
      (track.runtimeInSeconds ?? 0) > 0;

  return ListTile(
    title: Text(
      track.title ?? 'Unknown',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: hasArtist
        ? Text(
            track.artist!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : null,
    trailing: hasTime
        ? Text(
            getTrackTime(track.runtimeInSeconds ?? 0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : null,
  );
}

String getTrackTime(int seconds) {
  if (seconds == 0) return '';

  var min = (seconds / 60).truncate();
  var sec = seconds % 60;

  if (min == 0 && sec == 0) return '';
  if (min == 0) {
    return getTranslations()
        .fromKey(LocaleKey.secondsAbbrev)
        .replaceAll('{0}', sec.toString());
  }

  if (sec == 0) {
    return getTranslations()
        .fromKey(LocaleKey.minutesAbbrev)
        .replaceAll('{0}', min.toString());
  }
  return getTranslations()
      .fromKey(LocaleKey.minutesSecondsAbbrev)
      .replaceAll('{0}', min.toString())
      .replaceAll('{1}', sec.toString());
}
