class AudioStreamBuilderEvent {
  bool isLoading;
  bool isPlaying;

  AudioStreamBuilderEvent({
    required this.isLoading,
    required this.isPlaying,
  });

  AudioStreamBuilderEvent copyWith({
    bool? isLoading,
    bool? isPlaying,
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
  String? image;
  void Function()? customStopAction;

  AudioStreamOpenUrlModel({
    required this.title,
    required this.artist,
    this.image,
    this.customStopAction,
  });
}
