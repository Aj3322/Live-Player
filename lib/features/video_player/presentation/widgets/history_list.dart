import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/url.dart';
import '../../data/repositories/connection_history_repository.dart';
import '../dialog/edit_dialog.dart';
import '../providers/connection_history_provider.dart';
import '../screens/full_screen_player.dart';
class HistoryList extends ConsumerWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final historyAsync = ref.watch(connectionHistoryProvider);
    return    RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        ref.invalidate(connectionHistoryProvider);
        await Future.delayed(const Duration(seconds: 1));
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: historyAsync.when(
          data: (historyList) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Recent Connections',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: historyList.isEmpty
                    ? const Center(child: Text('No recent connections'))
                    : ListView.builder(
                  itemCount: historyList.length > 3 ? 3 : historyList.length,
                  itemBuilder: (context, index) {
                    final item = historyList[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(item.url),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              showEditDialog(context, item);
                            } else if (value == 'delete') {
                              await ConnectionHistoryRepository().deleteConnection(item.key);
                              ref.invalidate(connectionHistoryProvider); // Refresh list
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                        onTap: () {
                          URL=item.url;
                          debugPrint(URL);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenPlayer(initialUrl:item.url,),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
