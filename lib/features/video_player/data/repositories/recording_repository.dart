import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../../../../core/utils/helper.dart';
import '../models/video_recording.dart';

class VideoRecordingRepository {
  static final VideoRecordingRepository _instance = VideoRecordingRepository._internal();

  factory VideoRecordingRepository() => _instance;

  VideoRecordingRepository._internal();

  static const _boxName = 'recordings';

  late Box<VideoRecording> _box;

  /// Initialize Hive and open the box
  Future<void> init() async {
    Hive.registerAdapter(VideoRecordingAdapter());
    _box = await Hive.openBox<VideoRecording>(_boxName);
    syncWithStorage();
  }

  /// Add a new recording
  Future<void> addRecording(VideoRecording recording) async {
    await _box.add(recording);
  }

  /// Get all recordings
  List<VideoRecording> getAllRecordings() {
    return _box.values.toList();
  }

  /// Delete a recording by key and its associated file
  Future<void> deleteRecording(int key) async {
    final recording = _box.get(key);
    if (recording != null) {
      try {
        final file = File(recording.filePath);
        if (await file.exists()) {
          await file.delete();
        }
        await _box.delete(key);
      } catch (e) {
        debugPrint("Failed to delete file: ${e.toString()}");
        // Optionally rethrow or show an error
      }
    }
  }

  /// Clear all recordings and their files
  Future<void> clearAll() async {
    // Delete all files first
    try {
    for (final recording in _box.values) {
      final file = File(recording.filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    // Then clear the box
    await _box.clear();
    } catch (e) {
      debugPrint("Failed to delete file: ${e.toString()}");
      // Optionally rethrow or show an error
    }
  }

  /// Update a recording
  Future<void> updateRecording(int key, VideoRecording updated) async {
    await _box.put(key, updated);
  }

  /// Get a specific recording by key
  VideoRecording? getRecording(int key) {
    return _box.get(key);
  }

  /// Watch for changes in recording box
  Stream<BoxEvent> watch() {
    return _box.watch();
  }

  Future<bool> syncWithStorageOnStart() async {
    try {
      final recordingsInDb = _box.values.toList();
      for (final recording in recordingsInDb) {
        final file = File(recording.filePath);
        if (!await file.exists()) {
          await _box.delete(recording.key);
        }
      }
      return true;
    } catch (e) {
      debugPrint("Error during syncWithStorageOnStart: $e");
      return false;
    }
  }

  Stream<List<VideoRecording>> watchAllRecordings() async* {
    yield _box.values.toList();
    yield* _box.watch().map((_) => _box.values.toList().cast<VideoRecording>());
  }

  Future<bool> syncWithStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final isFirstRun = prefs.getBool('first_run') ?? true;
    if (isFirstRun) {
    try {
      final appDir = Directory("/storage/emulated/0/DCIM/RTSP/Video");
      // Check if directory exists
      if (!await appDir.exists()) {
        debugPrint("Video directory not found");
        return false;
      }

      // Get all video files from storage
      final List<FileSystemEntity> files = await appDir.list().toList();
      final videoFiles = files.whereType<File>().where(
              (file) => file.path.toLowerCase().endsWith('.mp4')
      ).toList();

      // Get all recordings from Hive
      final hiveRecordings = _box.values.toList();

      // Phase 2: Add new files to Hive
      int addedCount = 0;
      for (final file in videoFiles) {
        try {
          final filePath = file.path;
          final existsInHive = hiveRecordings.any((r) => r.filePath == filePath);

          if (!existsInHive) {
            final duration = await getVideoDuration(filePath);
            final fileStat = await file.stat();

            await _box.add(VideoRecording(
              filePath: filePath,
              fileName: file.path.split('/').last,
              durationSeconds: duration,
              recordedAt: fileStat.modified,
              fileSizeBytes: fileStat.size,
            ));
            addedCount++;
          }
        } catch (e) {
          debugPrint("Error adding new video ${file.path}: ${e.toString()}");
        }
      }

      // Verification: Check if counts match
      final finalFileCount = videoFiles.length;
      final finalDbCount = _box.length;
      final success = finalFileCount == finalDbCount;

      debugPrint('''
    Sync completed:
    - Files in storage: $finalFileCount
    - Entries in database: $finalDbCount
    - Added new: $addedCount
    ''');
      await prefs.setBool('first_run', false);
      return success;
    } catch (e) {
      debugPrint("Critical sync error: ${e.toString()}");
      return false;
    }
    }else{
      return await syncWithStorageOnStart();
    }
  }
}