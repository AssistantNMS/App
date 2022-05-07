class AudioStreamBuilderEvent {
  String title;
  String artist;
  String album;
  String image;
  bool isLoading;
  bool isPlaying;

  AudioStreamBuilderEvent({
    this.title,
    this.artist,
    this.album,
    this.image,
    this.isLoading,
    this.isPlaying,
  });

  AudioStreamBuilderEvent copyWith({
    String title,
    String artist,
    String album,
    String image,
    bool isLoading,
    bool isPlaying,
  }) {
    {
      return AudioStreamBuilderEvent(
        title: title ?? this.title,
        artist: artist ?? this.artist,
        album: album ?? this.album,
        image: image ?? this.image,
        isLoading: isLoading ?? this.isLoading,
        isPlaying: isPlaying ?? this.isPlaying,
      );
    }
  }
}

class AudioStreamOpenUrlModel {
  String title;
  String artist;
  String image;
  void Function() customStopAction;

  AudioStreamOpenUrlModel({
    this.title,
    this.artist,
    this.image,
    this.customStopAction,
  });
}
