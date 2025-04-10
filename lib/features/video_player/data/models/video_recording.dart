import 'package:hive/hive.dart';

part 'video_recording.g.dart';

@HiveType(typeId: 0)
class VideoRecording extends HiveObject {
  @HiveField(0)
  final String filePath;

  @HiveField(1)
  final String fileName;

  @HiveField(2)
  final int durationSeconds;

  @HiveField(3)
  final DateTime recordedAt;

  @HiveField(4)
  final int fileSizeBytes;

  @HiveField(5)
  final String? thumbnailPath;

  VideoRecording({
    required this.filePath,
    required this.fileName,
    required this.durationSeconds,
    required this.recordedAt,
    required this.fileSizeBytes,
    this.thumbnailPath,
  });
}
