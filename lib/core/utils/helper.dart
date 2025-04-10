import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

Future<int> getVideoDuration(String filePath) async {
  try {
    final controller = VideoPlayerController.file(File(filePath));
    await controller.initialize(); // Load video metadata
    final duration = controller.value.duration.inSeconds;
    await controller.dispose(); // Clean up
    return duration;
  } catch (e) {
    debugPrint("Error getting duration for $filePath: $e");
    return 0; // Fallback if extraction fails
  }
}