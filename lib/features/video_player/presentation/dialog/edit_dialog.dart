import 'package:flutter/material.dart';
import '../../data/models/connection_history.dart';
import '../../data/repositories/connection_history_repository.dart';

void showEditDialog(BuildContext context, ConnectionHistory item) {
  final nameController = TextEditingController(text: item.name);
  final urlController = TextEditingController(text: item.url);
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Connection'),
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
                final updated = item.copyWith(
                  name: name,
                  url: url,
                  protocol: Uri.tryParse(url)?.scheme ?? 'unknown',
                  ip: Uri.tryParse(url)?.host ?? '',
                  port: Uri.tryParse(url)?.port ?? 0,
                  connectedAt: DateTime.now(),
                );

                await ConnectionHistoryRepository().updateConnection(item.key,updated);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}