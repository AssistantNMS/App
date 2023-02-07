import 'package:flutter/material.dart';

import '../../contracts/misc/audio_stream_builder_event.dart';
import 'interface/i_audio_player_service.dart';

class WindowsAudioPlayerService extends IAudioPlayerService {
  @override
  Stream<bool> isPlaying() => Stream.value(false);

  @override
  Future<void> stop() => Future.value();

  @override
  Future<void> dispose() => Future.value();

  @override
  Future<void> openUrl(String audioUrl, AudioStreamOpenUrlModel model) {
    return Future.value();
  }

  @override
  Future<void> openLocal(
      String localPath, Key uniqueKey, AudioStreamOpenUrlModel model) {
    return Future.value();
  }

  @override
  Widget audioStreamBuilder({
    Key? uniqueKey,
    required BuildContext playerContext,
    required Widget Function(
      BuildContext audioContext,
      AudioStreamBuilderEvent audioStream,
    )
        builder,
  }) {
    return Container();
  }

  @override
  Widget audioLocalBuilder({
    Key? uniqueKey,
    required BuildContext playerContext,
    required Widget Function(
      BuildContext audioContext,
      AudioStreamBuilderEvent audioStream,
    )
        builder,
  }) {
    return Container();
  }
}

/*

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../contracts/misc/audio_stream_builder_event.dart';
import 'interface/i_audio_player_service.dart';

class WindowsAudioPlayerService extends IAudioPlayerService {
  AudioPlayer _player;
  Key uniqueKey;

  AudioPlayer getPlayer() {
    _player ??= AudioPlayer();
    return _player;
  }

  @override
  Stream<bool> isPlaying() =>
      Stream.value(getPlayer().state == PlayerState.playing);

  @override
  Future<void> stop() => getPlayer().stop();

  @override
  Future<void> dispose() => getPlayer().dispose();

  @override
  Future<void> openUrl(String audioUrl, AudioStreamOpenUrlModel model) {
    return getPlayer().play(UrlSource(audioUrl));
  }

  @override
  Future<void> openLocal(
    String localPath,
    Key uniqueKey,
    AudioStreamOpenUrlModel model,
  ) async {
    final bytes = await AudioCache.instance.loadAsBytes(localPath);
    this.uniqueKey = uniqueKey;
    return getPlayer().play(BytesSource(bytes));
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
    bool isPlaying = (getPlayer()?.state == PlayerState.playing) ?? false;

    AudioStreamBuilderEvent current = AudioStreamBuilderEvent(
      isLoading: false,
      isPlaying: isPlaying,
    );

    return builder(playerContext, current);
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
    return Container();
  }
}


 */
