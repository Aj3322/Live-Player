import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/video_recording.dart';
import '../../data/repositories/recording_repository.dart';

final videoRecordingProvider = StreamProvider<List<VideoRecording>>((ref) {
  return VideoRecordingRepository().watchAllRecordings();
});
