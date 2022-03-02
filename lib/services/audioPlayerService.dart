import 'package:assets_audio_player/assets_audio_player.dart';

class AudioPlayerService {
  AssetsAudioPlayer _player;
  // AudioPlayerService() {}

  AssetsAudioPlayer getPlayer() {
    if (this._player == null) {
      this._player = AssetsAudioPlayer.newPlayer();
    }
    return this._player;
  }

  Stream<bool> isPlaying() => this.getPlayer().isPlaying;

  Future<void> stop() => this.getPlayer().stop();

  Future<void> open(Audio audio) => this.getPlayer().open(
        audio,
        autoStart: true,
        showNotification: true,
      );
}
