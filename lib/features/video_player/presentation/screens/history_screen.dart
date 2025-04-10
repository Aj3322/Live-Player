import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_stream_pilot/features/video_player/data/repositories/connection_history_repository.dart';
import 'package:live_stream_pilot/features/video_player/presentation/widgets/history_list.dart';
import '../providers/connection_history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(connectionHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection History'),
        actions: [
          if (historyAsync.value!=null&&historyAsync.value!.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear History'),
                    content: const Text('Are you sure you want to clear all connection history?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          ConnectionHistoryRepository().clearAll();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body:HistoryList()
    );
  }
}