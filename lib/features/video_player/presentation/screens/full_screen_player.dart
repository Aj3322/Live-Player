import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:live_stream_pilot/features/video_player/data/repositories/recording_repository.dart';
import 'package:live_stream_pilot/features/video_player/data/models/video_recording.dart';
import 'package:live_stream_pilot/features/video_player/presentation/widgets/recording_timer.dart';
import 'package:permission_handler/permission_handler.dart';

enum ConnectionStatus {
  connected,
  reconnecting,
  disconnected,
  unknown
}

class FullScreenPlayer extends StatefulWidget {
  final String initialUrl;

  const FullScreenPlayer({
    super.key,
    required this.initialUrl,
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  VlcPlayerController? _controller;
  bool _isPlaying = false;
  bool _isRecording = false;
  bool _isFullScreen = false;
  bool _isBuffering = false;
  bool _isPopupMode = false;
  List<String> _recordings = [];
  String? _currentRecordingPath;
  int _recordingSeconds = 0;
  ConnectionStatus? _connectionStatus;
  Timer? _recordingTimer;
  Timer? _controlsTimer;
  bool _showControls = true;
  String _currentUrl = '';
  bool _isInitializing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.initialUrl;
    _initializePlayer();
    _startControlsTimer();
    _handlePermission();
  }

  Future<void> _initializePlayer() async {
    try {
      _controller = VlcPlayerController.network(
        _currentUrl,
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



      // Add listener only after successful initialization
      _controller?.addListener(_onPlayerStateChanged);

      setState(() {
        _isInitializing = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isInitializing = false;
        _errorMessage = 'Failed to initialize player: ${e.toString()}';
      });
      debugPrint('Player initialization error: $e');
    }
  }

  void _onPlayerStateChanged() {
    if (!mounted || _controller == null) return;

    final value = _controller!.value;

    // Buffering logic
    if (value.isPlaying && _isBuffering) {
      setState(() => _isBuffering = false);
    } else if (!value.isPlaying && !_isBuffering && value.isInitialized) {
      setState(() => _isBuffering = true);
    }

    // Connection status
    final currentStatus = _getConnectionStatus(value);
    if (currentStatus != _connectionStatus) {
      setState(() => _connectionStatus = currentStatus);
    }
  }

  ConnectionStatus _getConnectionStatus(VlcPlayerValue value) {
    if (value.hasError) {
      return ConnectionStatus.disconnected;
    } else if (value.isBuffering || (!value.isPlaying)) {
      return ConnectionStatus.reconnecting;
    } else if (value.isPlaying) {
      return ConnectionStatus.connected;
    }
    return ConnectionStatus.unknown;
  }

  Future<void> _handlePermission() async {
    final bool status = await FlutterOverlayWindow.isPermissionGranted();
    if (!status) {
      await FlutterOverlayWindow.requestPermission();
    }
  }

  void _startControlsTimer() {
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _resetControlsTimer() {
    _controlsTimer?.cancel();
    if (!_showControls) {
      setState(() => _showControls = true);
    }
    _startControlsTimer();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _controller?.pause();
    } else {
      await _controller?.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  Future<void> _toggleRecording() async {
    try {
      if (_isRecording) {
        // STOP RECORDING
        await _controller?.stopRecording();
        _recordingTimer?.cancel();

        if (_currentRecordingPath != null) {
          final directoryPath = _currentRecordingPath!;
          final duration = _recordingSeconds;

          try {
            // Find the most recently created video file in the directory
            final directory = Directory(directoryPath);
            final files = await directory.list().toList();

            // Filter for video files and sort by modification date
            final videoFiles = await Future.wait(
                files.where((file) => file is File && file.path.endsWith('.mp4')).map((file) async {
                  final fileStat = await (file as File).stat();
                  return {
                    'file': file,
                    'modified': fileStat.modified
                  };
                }
                ));

            if (videoFiles.isEmpty) {
              throw Exception('No video files found in directory: $directoryPath');
            }

            videoFiles.sort((a, b) => (b['modified'] as DateTime).compareTo((a['modified'] as DateTime)));
            final mostRecentFile = videoFiles.first['file'] as File;
            final recordingPath = mostRecentFile.path;

            final fileSize = await mostRecentFile.length();
            final fileName = recordingPath.split('/').last;

            setState(() {
              _isRecording = false;
              _recordings = [..._recordings, recordingPath];
              _currentRecordingPath = null;
              _recordingSeconds = 0;
            });

            final recording = VideoRecording(
              filePath: recordingPath,
              fileName: fileName,
              durationSeconds: duration,
              recordedAt: DateTime.now(),
              fileSizeBytes: fileSize,
            );
            await VideoRecordingRepository().addRecording(recording);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '📁 Recording saved at:\n$recordingPath\n⏱ Duration: ${_formatDuration(duration)}',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 4),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Error saving recording: ${e.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
            rethrow;
          }
        }
      } else {
        // START RECORDING - WITH PERMISSION CHECK
        try {
          final status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Storage permission is required to record videos'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'SETTINGS',
                  onPressed: () => openAppSettings(),
                ),
                duration: const Duration(seconds: 5),
              ),
            );
            return;
          }

          // Generate path in external storage
          final path = "/storage/emulated/0/DCIM/RTSP/Video";

          final directory = Directory(path);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }

          // Start recording
          final success = await _controller?.startRecording(path);

          if (success != null && success) {
            setState(() {
              _isRecording = true;
              _currentRecordingPath = path;
              _recordingSeconds = 0;
            });

            _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
              if (mounted) {
                setState(() => _recordingSeconds++);
              }
            });
          } else {
            throw Exception('Failed to start recording - controller returned false');
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Error starting recording: ${e.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ));
          rethrow;
        }
      }
    } catch (e) {
      debugPrint('Error in toggleRecording: $e');
      rethrow;
    }
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _toggleFullScreen() {
    if (_isFullScreen) {
      _unlockOrientation();
    } else {
      _lockLandscapeOrientation();
    }
    setState(() => _isFullScreen = !_isFullScreen);
  }

  void _lockLandscapeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _togglePopupMode() {
    setState(() => _isPopupMode = !_isPopupMode);
  }

  void _unlockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _updateCurrentUrl(String newUrl) {
    setState(() => _currentUrl = newUrl);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.blue;
    String label = '';

    switch (_connectionStatus) {
      case ConnectionStatus.connected:
        color = Colors.green;
        label = 'Connected';
        break;
      case ConnectionStatus.reconnecting:
        color = Colors.orange;
        label = 'Reconnecting';
        break;
      case ConnectionStatus.disconnected:
        color = Colors.red;
        label = 'Disconnected';
        break;
      case ConnectionStatus.unknown:
        color = Colors.grey;
        label = 'Unknown';
        break;
      case null:
        color = Colors.blue;
        label = _isInitializing ? 'Initializing' : 'Status unknown';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(label, style: TextStyle(color: color)),
        actions: [
          if (_errorMessage != null)
            IconButton(
              icon: const Icon(Icons.error, color: Colors.red),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_errorMessage!),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          if (_isInitializing)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      backgroundColor: Colors.black,
      body: _buildPlayerContent(),
    );
  }

  Widget _buildPlayerContent() {
    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 20),
            Text(
              'Player Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initializePlayer,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Center(
          child: InkWell(
            onTap: _resetControlsTimer,
            onDoubleTap: _toggleFullScreen,
            child: SizedBox(
              height: double.maxFinite,
              width: double.infinity,
              child: VlcPlayer(
                controller: _controller!,
                aspectRatio: 9 / 16,
                placeholder: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ),
        if (_isBuffering)
          const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        if (_isPopupMode)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Video is playing in popup window"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await FlutterOverlayWindow.closeOverlay();
                    _togglePopupMode();
                  },
                  child: const Text("Return to main view"),
                ),
              ],
            ),
          ),
        if (_showControls)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.picture_in_picture,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await FlutterOverlayWindow.showOverlay();
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  color: _isRecording ? Colors.red : null,
                  onPressed: _controller?.value.isInitialized == true
                      ? _toggleRecording
                      : null,
                  icon: Icon(_isRecording
                      ? Icons.stop
                      : Icons.fiber_manual_record),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: _toggleFullScreen,
                  icon: const Icon(Icons.fullscreen_exit),
                ),
              ],
            ),
          ),
        if (_isRecording)
          Positioned(
            top: 20,
            left: 20,
            child: RecordingTimer(seconds: _recordingSeconds),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.removeListener(_onPlayerStateChanged);
    _controller?.dispose();
    _recordingTimer?.cancel();
    _controlsTimer?.cancel();
    _unlockOrientation();
    super.dispose();
  }
}