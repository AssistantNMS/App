import 'package:flutter/material.dart';

import '../../../contracts/misc/audio_stream_builder_event.dart';

abstract class IAudioPlayerService {
  Stream<bool> isPlaying();
  Future<void> stop();
  Future<void> dispose();
  Future<void> openUrl(String audioUrl, AudioStreamOpenUrlModel model);
  Future<void> openLocal(
    String localPath,
    Key uniqueKey,
    AudioStreamOpenUrlModel model,
  );

  Widget audioStreamBuilder({
    Key? uniqueKey,
    required BuildContext playerContext,
    required Widget Function(
      BuildContext audioContext,
      AudioStreamBuilderEvent audioStream,
    ) builder,
  });

  Widget audioLocalBuilder({
    Key? uniqueKey,
    required BuildContext playerContext,
    required Widget Function(
      BuildContext audioContext,
      AudioStreamBuilderEvent audioStream,
    ) builder,
  });
}
