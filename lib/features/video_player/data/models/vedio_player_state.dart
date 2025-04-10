class VideoPlayerState {
  final String currentUrl;
  final bool isRecording;
  final bool isPiPMode;
  final List<String> recordedVideos;
  final String? recordingPath;

  VideoPlayerState({
    required this.currentUrl,
    this.isRecording = false,
    this.isPiPMode = false,
    this.recordedVideos = const [],
    this.recordingPath,
  });

  VideoPlayerState copyWith({
    String? currentUrl,
    bool? isRecording,
    bool? isPiPMode,
    List<String>? recordedVideos,
    String? recordingPath,
    bool clearRecordingPath = false,
  }) {
    return VideoPlayerState(
      currentUrl: currentUrl ?? this.currentUrl,
      isRecording: isRecording ?? this.isRecording,
      isPiPMode: isPiPMode ?? this.isPiPMode,
      recordedVideos: recordedVideos ?? this.recordedVideos,
      recordingPath: clearRecordingPath ? null : recordingPath ?? this.recordingPath,
    );
  }
}