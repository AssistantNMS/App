import 'package:flutter/material.dart';

import '../../contracts/misc/audioStreamBuilderEvent.dart';
import 'interface/IAudioPlayerService.dart';

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
    Key uniqueKey,
    Widget Function(
      BuildContext audioContext,
      AudioStreamBuilderEvent audioStream,
    )
        builder,
  }) {
    return Container();
  }

  @override
  Widget audioLocalBuilder({
    Key uniqueKey,
    Widget Function(
      BuildContext audioContext,
      AudioStreamBuilderEvent audioStream,
    )
        builder,
  }) {
    return Container();
  }
}
