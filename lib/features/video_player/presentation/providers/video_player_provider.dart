// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:live_stream_pilot/features/video_player/data/repositories/recording_repository.dart';
// import 'package:live_stream_pilot/features/video_player/presentation/widgets/full_screen_player.dart';
// import '../../../../core/constants/url.dart';
// import '../../data/models/video_recording.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../screens/video_player_screen.dart';
//
//
// class VideoPlayerState {
//   final String url;
//   final String currentUrl;
//   final bool isPlaying;
//   final bool isRecording;
//   final bool isBuffering;
//   final bool isFullScreen;
//   final bool isPopupMode;
//   final List<String> recordings;
//   final String? currentRecordingPath;
//   final int recordingSeconds;
//   ConnectionStatus? conStatus;
//   VlcPlayerController? controller;
//
//   VideoPlayerState({
//     required this.url,
//     this.currentUrl = '',
//     this.isPlaying = false,
//     this.isRecording = false,
//     this.isFullScreen = false,
//     this.isBuffering=false,
//     this.isPopupMode = false,
//     this.recordings = const [],
//     this.currentRecordingPath,
//     this.recordingSeconds = 0,
//     this.controller ,
//     this.conStatus,
//   });
//
//   VideoPlayerState copyWith({
//     String? url,
//     String? currentUrl,
//     bool? isPlaying,
//     bool? isRecording,
//     bool? isBuffering,
//     bool? isFullScreen,
//     List<String>? recordings,
//     String? currentRecordingPath,
//     int? recordingSeconds,
//     bool? isPopupMode,
//     ConnectionStatus? conStatus,
//   }) {
//     return VideoPlayerState(
//       url: url ?? this.url,
//       currentUrl: currentUrl ?? this.currentUrl,
//       isPlaying: isPlaying ?? this.isPlaying,
//       isRecording: isRecording ?? this.isRecording,
//       isFullScreen: isFullScreen ?? this.isFullScreen,
//       recordings: recordings ?? this.recordings,
//       currentRecordingPath: currentRecordingPath ?? this.currentRecordingPath,
//       recordingSeconds: recordingSeconds ?? this.recordingSeconds,
//       isBuffering: isBuffering??this.isBuffering,
//       isPopupMode: isPopupMode ?? this.isPopupMode,
//       controller: controller, conStatus: conStatus
//     );
//   }
// }
//
// class VideoPlayerNotifier extends StateNotifier<VideoPlayerState> {
//   VideoPlayerNotifier()
//       : super(VideoPlayerState(url: 'rtsp://192.168.1.2:5540/ch0'));
//   Timer? _recordingTimer;
//
//   void initialize(){
//    if(state.controller==null){
//      state.controller= VlcPlayerController.network(
//        URL,
//        hwAcc: HwAcc.full,
//        options: VlcPlayerOptions(
//          advanced: VlcAdvancedOptions([
//            VlcAdvancedOptions.networkCaching(2000),
//          ]),
//          video: VlcVideoOptions([
//            VlcVideoOptions.dropLateFrames(true),
//            VlcVideoOptions.skipFrames(true),
//          ]),
//        ),
//      );
//      state.controller?.addListener(_onPlayerStateChanged);
//    }
//   }
//
//
//   void updateCurrentUrl(String newUrl) {
//     state = state.copyWith(currentUrl: newUrl);
//   }
//   ConnectionStatus? _lastStatus;
//   void _onPlayerStateChanged() {
//     if(state.controller!=null){
//       final value = state.controller?.value;
//
//       // Buffering logic
//       if (value!.isPlaying && state.isBuffering) {
//         state.copyWith(isBuffering: false);
//       } else if (!value.isPlaying && !state.isBuffering && value.isInitialized) {
//         state.copyWith(isBuffering: true);
//       }
//
//       // Detect connection status
//       final currentStatus = _getConnectionStatus(value);
//       if (currentStatus != _lastStatus) {
//         state.conStatus=currentStatus;
//         _lastStatus = currentStatus;
//       }
//     }
//   }
//
//   ConnectionStatus _getConnectionStatus(VlcPlayerValue value) {
//     if (value.hasError) {
//       return ConnectionStatus.disconnected;
//     } else if (value.isBuffering || (!value.isPlaying)) {
//       return ConnectionStatus.reconnecting;
//     } else if (value.isPlaying) {
//       return ConnectionStatus.connected;
//     }
//     return ConnectionStatus.unknown;
//   }
//
//   Future<void> togglePlayPause(VlcPlayerController controller) async {
//     if (state.isPlaying) {
//       await controller.pause();
//     } else {
//       await controller.play();
//     }
//     state = state.copyWith(isPlaying: !state.isPlaying);
//   }
//
//   Future<void> toggleRecording(VlcPlayerController controller, BuildContext context) async {
//     try {
//       if (state.isRecording) {
//         // STOP RECORDING
//         await controller.stopRecording();
//         _recordingTimer?.cancel();
//
//         if (state.currentRecordingPath != null) {
//           final directoryPath = state.currentRecordingPath!;
//           final duration = state.recordingSeconds;
//
//           try {
//             // Find the most recently created video file in the directory
//             final directory = Directory(directoryPath);
//             final files = await directory.list().toList();
//
//             // Filter for video files and sort by modification date
//             final videoFiles = await Future.wait(
//                 files.where((file) => file is File && file.path.endsWith('.mp4')).map((file) async {
//                   final fileStat = await (file as File).stat();
//                   return {
//                     'file': file,
//                     'modified': fileStat.modified
//                   };
//                 }
//                 ));
//
//                 if (videoFiles.isEmpty) {
//               throw Exception('No video files found in directory: $directoryPath');
//             }
//
//             videoFiles.sort((a, b) => (b['modified'] as DateTime).compareTo((a['modified'] as DateTime)));
//             final mostRecentFile = videoFiles.first['file'] as File;
//             final recordingPath = mostRecentFile.path;
//
//             final fileSize = await mostRecentFile.length();
//             final fileName = recordingPath.split('/').last;
//
//             state = state.copyWith(
//               isRecording: false,
//               recordings: [...state.recordings, recordingPath],
//               currentRecordingPath: null,
//               recordingSeconds: 0,
//             );
//
//             final recording = VideoRecording(
//               filePath: recordingPath,
//               fileName: fileName,
//               durationSeconds: duration,
//               recordedAt: DateTime.now(),
//               fileSizeBytes: fileSize,
//             );
//             await VideoRecordingRepository().addRecording(recording);
//
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(
//                   '📁 Recording saved at:\n$recordingPath\n⏱ Duration: ${_formatDuration(duration)}',
//                 ),
//                 backgroundColor: Colors.green,
//                 duration: const Duration(seconds: 4),
//               ),
//             );
//           } catch (e) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('❌ Error saving recording: ${e.toString()}'),
//                 backgroundColor: Colors.red,
//                 duration: const Duration(seconds: 4),
//               ),
//             );
//             rethrow;
//           }
//         }
//       } else {
//         // START RECORDING - WITH PERMISSION CHECK
//         try {
//           final status = await Permission.manageExternalStorage.request();
//           if (!status.isGranted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: const Text('Storage permission is required to record videos'),
//                 backgroundColor: Colors.red,
//                 action: SnackBarAction(
//                   label: 'SETTINGS',
//                   onPressed: () => openAppSettings(),
//                 ),
//                 duration: const Duration(seconds: 5),
//               ),
//             );
//             return;
//           }
//
//           // Generate path in external storage
//           final path = "/storage/emulated/0/DCIM/RTSP/Video";
//
//           final directory = Directory(path);
//           if (!await directory.exists()) {
//             await directory.create(recursive: true);
//           }
//
//           // Start recording
//           final success = await controller.startRecording(path);
//
//           if (success != null && success) {
//             state = state.copyWith(
//               isRecording: true,
//               currentRecordingPath: path,
//               recordingSeconds: 0,
//             );
//
//             _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//               state = state.copyWith(recordingSeconds: state.recordingSeconds + 1);
//             });
//           } else {
//             throw Exception('Failed to start recording - controller returned false');
//           }
//         } catch (e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('❌ Error starting recording: ${e.toString()}'),
//               backgroundColor: Colors.red,
//               duration: const Duration(seconds: 4),
//             ),
//           );
//           rethrow;
//         }
//       }
//     } catch (e) {
//       debugPrint('Error in toggleRecording: $e');
//       rethrow;
//     }
//   }
//   String _formatDuration(int totalSeconds) {
//     final minutes = totalSeconds ~/ 60;
//     final seconds = totalSeconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }
//
//   void toggleFullScreen() {
//     if (state.isFullScreen) {
//       _unlockOrientation();
//     } else {
//       _lockLandscapeOrientation();
//     }
//     state = state.copyWith(isFullScreen: !state.isFullScreen);
//   }
//   void _lockLandscapeOrientation() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.landscapeLeft,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//   }
//   void togglePopupMode() {
//     state = state.copyWith(isPopupMode: !state.isPopupMode);
//   }
//   void _unlockOrientation() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//   }
// }
//
// final videoPlayerProvider =
// StateNotifierProvider<VideoPlayerNotifier, VideoPlayerState>((ref) {
//   final notifier = VideoPlayerNotifier();
//   notifier.initialize();
//   return notifier;
// });