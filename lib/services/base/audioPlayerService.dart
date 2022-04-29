import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../../contracts/misc/audioStreamBuilderEvent.dart';
import 'interface/IAudioPlayerService.dart';

class AudioPlayerService extends IAudioPlayerService {
  AssetsAudioPlayer _player;

  AssetsAudioPlayer getPlayer() {
    _player ??= AssetsAudioPlayer.newPlayer();
    return _player;
  }

  @override
  Stream<bool> isPlaying() => getPlayer().isPlaying;

  @override
  Future<void> stop() => getPlayer().stop();

  @override
  Future<void> dispose() => getPlayer().dispose();

  @override
  Future<void> openUrl(String audioUrl, AudioStreamOpenUrlModel model) {
    return getPlayer().open(
      Audio.liveStream(
        audioUrl,
        metas: Metas(
          title: model.title,
          artist: model.artist,
          image: MetasImage.network(model.image),
        ),
      ),
      autoStart: true,
      showNotification: true,
      notificationSettings: NotificationSettings(
        nextEnabled: false,
        prevEnabled: false,
        customStopAction: (AssetsAudioPlayer player) {
          try {
            player.stop();
            stop();
          } catch (e) {
            // unused
          }
          model.customStopAction();
        },
      ),
    );
  }

  @override
  Future<void> openLocal(String localPath, AudioStreamOpenUrlModel model) {
    return getPlayer().open(
      Audio(
        localPath,
        metas: Metas(title: model.title, artist: model.artist),
      ),
      autoStart: true,
      showNotification: true,
    );
  }

  @override
  Widget audioStreamBuilder({
    Widget Function(
            BuildContext audioContext, AudioStreamBuilderEvent audioStream)
        builder,
  }) {
    return StreamBuilder(
      stream: getPlayer().current,
      builder: (BuildContext audioCtx, AsyncSnapshot<Playing> asyncSnapshot) {
        final Audio audio = asyncSnapshot?.data?.audio?.audio;
        bool isLoading =
            asyncSnapshot.connectionState == ConnectionState.done &&
                audio == null;

        AudioStreamBuilderEvent current = AudioStreamBuilderEvent(
          title: '',
          artist: '',
          album: '',
          image: '',
          isLoading: isLoading,
          isPlaying: true,
        );

        if (!isLoading) {
          Metas metas = (audio?.metas != null) ? audio?.metas : null;
          String title = metas?.title;
          String artist = metas?.artist;
          current = current.copyWith(
            title: title,
            artist: artist,
            album: getTranslations().fromKey(LocaleKey.nmsfm),
            image: '',
            isLoading: isLoading,
          );
        }

        return builder(audioCtx, current);
      },
    );
  }

  // @override
  // Widget audioLocalBuilder({
  //   Widget Function(
  //           BuildContext audioContext, AudioStreamBuilderEvent audioStream)
  //       builder,
  // }) {
  //   return StreamBuilder(
  //     stream: getPlayer().isPlaying,
  //     builder: (BuildContext context, AsyncSnapshot<bool> asyncSnapshot) {
  //       bool isLoading = asyncSnapshot.connectionState == ConnectionState.done;
  //       bool isPlaying =
  //           asyncSnapshot.data.processingState == ProcessingState.ready;
  //       final Audio current = asyncSnapshot?.data?.audio?.audio;

  //       bool isLoading = isPlaying == true && current == null;
  //       bool localIsPlaying = isPlaying;
  //       if (current == null) {
  //         localIsPlaying = false;
  //       }
  //       Metas metas = (current?.metas != null) ? current?.metas : null;
  //       String title = metas?.title;
  //       String artist = metas?.artist;

  //       AudioStreamBuilderEvent current = AudioStreamBuilderEvent(
  //         title: '',
  //         artist: '',
  //         album: '',
  //         image: '',
  //         isLoading: isLoading,
  //         isPlaying: isPlaying,
  //       );

  //       if (!isLoading) {
  //         PlaybackEvent data = asyncSnapshot?.data;
  //         current = current.copyWith(
  //           title: data.icyMetadata?.info?.title ?? '',
  //           artist: data.icyMetadata?.headers?.name ?? '',
  //           album: '',
  //           image: data.icyMetadata?.info?.url ?? '',
  //           isLoading: isLoading,
  //           isPlaying: isPlaying,
  //         );
  //       }

  //       return builder(audioContext, current);
  //     },
  //   );
  // }
}
