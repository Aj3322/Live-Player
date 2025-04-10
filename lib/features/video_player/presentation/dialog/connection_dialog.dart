import 'package:flutter/material.dart';
import '../../../../core/constants/url.dart';
import '../../data/models/connection_history.dart';
import '../../data/repositories/connection_history_repository.dart';
import '../screens/full_screen_player.dart';

void showConnectDialog(BuildContext context) {
  final nameController = TextEditingController();
  final urlController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Connect to RTSP Stream'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(labelText: 'RTSP URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final url = urlController.text.trim();

              if (name.isNotEmpty && url.isNotEmpty) {
                final connection = ConnectionHistory(
                  name: name,
                  url: url,
                  addedAt: DateTime.now(),
                  protocol: Uri.tryParse(url)?.scheme ?? 'unknown',
                  ip: Uri.tryParse(url)?.host ?? '',
                  port: Uri.tryParse(url)?.port ?? 0,
                  connectedAt: DateTime.now(),
                  status: 'pending',
                );

                await ConnectionHistoryRepository().addConnection(connection);

                if (context.mounted) {
                  URL=url;
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenPlayer(initialUrl: url,),
                    ),
                  );
                }
              }
            },
            child: const Text('Connect'),
          ),
        ],
      );
    },
  );
}