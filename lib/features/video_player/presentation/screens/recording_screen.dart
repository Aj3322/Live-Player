import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_stream_pilot/features/video_player/data/repositories/recording_repository.dart';
import '../widgets/vedio_recording_list.dart';

class RecordingsScreen extends ConsumerWidget {
  const RecordingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorded Videos'),
        actions: [
           IconButton(onPressed: (){VideoRecordingRepository().syncWithStorage();}, icon: Icon(Icons.refresh))
        ],
      ),
      body:RecordingList()
    );
  }
}