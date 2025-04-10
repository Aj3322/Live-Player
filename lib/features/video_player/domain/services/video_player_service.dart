import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter/material.dart';

class VlcPlayerService {
  VlcPlayerController? _controller;
  String? _currentStreamUrl;

  /// Public getter for accessing the controller
  VlcPlayerController? get controller => _controller;

  /// Whether the controller is initialized
  bool get isInitialized => _controller?.value.isInitialized ?? false;

  /// Initialize the controller with a stream URL
  Future<void> initialize(String streamUrl, {bool autoPlay = true,void Function()? onStateChanged}) async {
    try {
      // Dispose any existing controller
      await dispose();

      _currentStreamUrl = streamUrl;

      _controller = VlcPlayerController.network(
       _currentStreamUrl!,
        hwAcc: HwAcc.full,
        options: VlcPlayerOptions(
          advanced: VlcAdvancedOptions([
            VlcAdvancedOptions.networkCaching(2000),
          ]),
          video: VlcVideoOptions([
            VlcVideoOptions.dropLateFrames(true),
            VlcVideoOptions.skipFrames(true),
          ]),
        ),
      );
      if(onStateChanged!=null){
        _controller?.addListener(onStateChanged);
      }
      await _controller!.initialize();
    } catch (e) {
      debugPrint("VLC Initialization Error: $e");
      rethrow;
    }
  }

  /// Play stream
  void play() {
    if (_controller != null && !_controller!.value.isPlaying) {
      _controller!.play();
    }
  }

  /// Pause stream
  void pause() {
    if (_controller != null && _controller!.value.isPlaying) {
      _controller!.pause();
    }
  }

  /// Toggle play/pause
  void togglePlayPause() {
    if (_controller == null) return;

    if (_controller!.value.isPlaying) {
      pause();
    } else {
      play();
    }
  }

  /// Stop stream
  void stop() {
    _controller?.stop();
  }

  /// Dispose controller
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }

  /// Reconnect to the last stream
  Future<void> reconnect() async {
    if (_currentStreamUrl != null) {
      await initialize(_currentStreamUrl!);
    }
  }
}
