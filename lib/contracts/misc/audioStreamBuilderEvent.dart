class AudioStreamBuilderEvent {
  bool isLoading;
  bool isPlaying;

  AudioStreamBuilderEvent({
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
