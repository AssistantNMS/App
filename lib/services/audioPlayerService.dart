import 'package:assets_audio_player/assets_audio_player.dart';

class AudioPlayerService {
  AssetsAudioPlayer _player;
  // AudioPlayerService() {}

  AssetsAudioPlayer getPlayer() {
    _player ??= AssetsAudioPlayer.newPlayer();
    return _player;
  }

  Stream<bool> isPlaying() => getPlayer().isPlaying;

  Future<void> stop() => getPlayer().stop();

  Future<void> open(Audio audio) => getPlayer().open(
        audio,
        autoStart: true,
        showNotification: true,
      );
}
