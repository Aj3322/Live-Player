import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import '../../data/repositories/recording_repository.dart';
import '../providers/video_recording_provider.dart';

class RecordingList extends ConsumerWidget {
  const RecordingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordingAsync = ref.watch(videoRecordingProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(videoRecordingProvider);
        await Future.delayed(const Duration(seconds: 1));
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: recordingAsync.when(
          data: (recordingList) => Expanded(
            child: recordingList.isEmpty
                ? const Center(child: Text('No recordings found'))
                : ListView.builder(
              itemCount: recordingList.length,
              itemBuilder: (context, index) {
                final recording = recordingList[index];
                return Card(
                  child: ListTile(
                    title: Text(recording.fileName,overflow: TextOverflow.ellipsis,),
                    subtitle:  Row(
                      children: [
                        Text(formatBytes(recording.fileSizeBytes)),
                        SizedBox(width: 10),
                        Text(formatDuration(recording.durationSeconds)),
                      ],
                    )
                    ,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'delete') {
                          await VideoRecordingRepository()
                              .deleteRecording(recording.key);
                          ref.invalidate(videoRecordingProvider);
                        } else if (value == 'play') {
                          OpenFilex.open(recording.filePath);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'play',
                          child: Text('Play'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                    onTap: () {
                      OpenFilex.open(recording.filePath);
                    },
                  ),
                );
              },
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
  String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

}
