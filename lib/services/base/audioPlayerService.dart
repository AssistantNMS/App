import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import '../../contracts/misc/audioStreamBuilderEvent.dart';
import 'interface/IAudioPlayerService.dart';

class AudioPlayerService extends IAudioPlayerService {
  AssetsAudioPlayer _player;
  Key uniqueKey;

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
  Future<void> openLocal(
    String localPath,
    Key uniqueKey,
    AudioStreamOpenUrlModel model,
  ) {
    this.uniqueKey = uniqueKey;
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
    Key uniqueKey,
    BuildContext playerContext,
    Widget Function(
      BuildContext audioContext,
      AudioStreamBuilderEvent audioStream,
    )
        builder,
  }) {
    return StreamBuilder(
      stream: getPlayer().isPlaying,
      builder: (BuildContext audioCtx, AsyncSnapshot<bool> asyncSnapshot) {
        bool isLoading = asyncSnapshot.connectionState != ConnectionState.done;
        bool isPlaying = asyncSnapshot.data ?? false;

        AudioStreamBuilderEvent current = AudioStreamBuilderEvent(
          isLoading: isLoading,
          isPlaying: isPlaying,
        );

        return builder(audioCtx, current);
      },
    );
  }

  @override
  Widget audioLocalBuilder({
    Key uniqueKey,
    BuildContext playerContext,
    Widget Function(
      BuildContext audioContext,
      AudioStreamBuilderEvent audioStream,
    )
        builder,
  }) {
    return StreamBuilder(
      stream: getPlayer().isPlaying,
      builder: (BuildContext audioCtx, AsyncSnapshot<bool> asyncSnapshot) {
        bool isLoading = asyncSnapshot.connectionState == ConnectionState.done;
        bool isPlaying = asyncSnapshot.data ?? false;

        if (this.uniqueKey != uniqueKey) {
          isPlaying = false;
        }

        AudioStreamBuilderEvent current = AudioStreamBuilderEvent(
          isLoading: isLoading,
          isPlaying: isPlaying,
        );

        return builder(audioCtx, current);
      },
    );
  }
}
