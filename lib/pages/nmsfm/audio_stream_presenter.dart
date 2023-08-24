import 'dart:async';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../constants/app_duration.dart';
import '../../constants/app_image.dart';
import '../../constants/nmsfm.dart';
import '../../contracts/misc/audio_stream_builder_event.dart';
import '../../contracts/nmsfm/zeno_fm_now_playing.dart';
import '../../integration/dependency_injection.dart';
import '../../services/api/zeno_fm_api_service.dart';

class AudioStreamPresenter extends StatefulWidget {
  const AudioStreamPresenter({Key? key}) : super(key: key);

  @override
  _AudioStreamPresenterWidget createState() => _AudioStreamPresenterWidget();
}

class _AudioStreamPresenterWidget extends State<AudioStreamPresenter> {
  Timer _timer =
      Timer.periodic(AppDuration.zenoFMRefreshInterval, (Timer t) {});
  String _title = '';
  String _artist = '';
  bool isPlaying = false;

  _AudioStreamPresenterWidget() {
    _timer.cancel();
    _timer = Timer.periodic(
      AppDuration.zenoFMRefreshInterval,
      (Timer t) => timerTick(t),
    );
  }

  timerTick(Timer t) async {
    if (isPlaying == false) return;

    ZenoFMApiService service = ZenoFMApiService();
    ResultWithValue<ZenoFmNowPlaying> nowPlayingResult =
        await service.getNowPlaying(nmsfmId);
    if (nowPlayingResult.hasFailed) {
      getLog().i('nowPlayingResult failed');
      return;
    }

    setState(() {
      _title = nowPlayingResult.value.title;
      _artist = nowPlayingResult.value.artist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return getAudioPlayer().audioStreamBuilder(
      uniqueKey: const Key('Streaming'),
      playerContext: context,
      builder: (BuildContext context, AudioStreamBuilderEvent event) {
        bool isLoading = event.isLoading;

        String title = getTranslations().fromKey(LocaleKey.nmsfm);
        if (_title.isNotEmpty) title = _title;

        String artist = 'Now Streaming'; // TODO translate
        getLog().i('_artist: ' + _artist);
        if (_artist.isNotEmpty) artist = _artist;

        Widget playStopWidget = (event.isPlaying)
            ? const CorrectlySizedImageFromIcon(icon: Icons.stop)
            : const CorrectlySizedImageFromIcon(icon: Icons.play_arrow);

        return ListTile(
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(artist, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: isLoading
              ? getLoading().smallLoadingIndicator() //
              : playStopWidget,
          onTap: () {
            void Function() stopFunction;
            stopFunction = () {
              getAudioPlayer().stop();
              setState(() {
                isPlaying = false;
              });
            };
            if (event.isPlaying) {
              stopFunction();
              return;
            }
            getAudioPlayer().openUrl(
              ZenoFMUrlTemplate.streamUrl.replaceAll('{0}', nmsfmId),
              AudioStreamOpenUrlModel(
                title: title,
                artist: artist,
                image: AppImage.nmsfm,
              ),
            );
            setState(() {
              isPlaying = true;
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // ignore: unnecessary_null_comparison
    if (_timer != null && _timer.isActive) _timer.cancel();
    super.dispose();
  }
}

class LocalAudioPresenter extends StatelessWidget {
  final String name;
  final String artist;
  final String localPath;
  const LocalAudioPresenter(this.name, this.artist, this.localPath, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Key uniqueKey = Key(localPath);
    return getAudioPlayer().audioLocalBuilder(
      uniqueKey: uniqueKey,
      playerContext: context,
      builder: (BuildContext context, AudioStreamBuilderEvent event) {
        bool isPlaying = event.isPlaying;

        if (event.isLoading) {
          return getLoading().smallLoadingTile(context);
        }

        return ListTile(
          title: Text(
            name + ' (Sample)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: isPlaying
              ? const CorrectlySizedImageFromIcon(icon: Icons.stop)
              : const CorrectlySizedImageFromIcon(icon: Icons.play_arrow),
          onTap: () {
            if (isPlaying) {
              getAudioPlayer().stop();
              return;
            }
            getAudioPlayer().openLocal(
              'assets/audio/$localPath',
              uniqueKey,
              AudioStreamOpenUrlModel(title: name, artist: artist),
            );
          },
        );
      },
    );
  }
}
