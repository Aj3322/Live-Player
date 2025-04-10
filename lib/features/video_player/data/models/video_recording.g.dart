// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_recording.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoRecordingAdapter extends TypeAdapter<VideoRecording> {
  @override
  final int typeId = 0;

  @override
  VideoRecording read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VideoRecording(
      filePath: fields[0] as String,
      fileName: fields[1] as String,
      durationSeconds: fields[2] as int,
      recordedAt: fields[3] as DateTime,
      fileSizeBytes: fields[4] as int,
      thumbnailPath: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VideoRecording obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.filePath)
      ..writeByte(1)
      ..write(obj.fileName)
      ..writeByte(2)
      ..write(obj.durationSeconds)
      ..writeByte(3)
      ..write(obj.recordedAt)
      ..writeByte(4)
      ..write(obj.fileSizeBytes)
      ..writeByte(5)
      ..write(obj.thumbnailPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoRecordingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
