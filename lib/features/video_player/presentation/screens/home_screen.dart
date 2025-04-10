import 'package:flutter/material.dart';
import 'package:live_stream_pilot/features/video_player/presentation/screens/history_screen.dart';
import 'package:live_stream_pilot/features/video_player/presentation/screens/recording_screen.dart';
import 'package:live_stream_pilot/features/video_player/presentation/widgets/history_list.dart';
import '../dialog/connection_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RTSP Stream Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen(),));
            },
          ),
          IconButton(
            icon: const Icon(Icons.folder),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RecordingsScreen(),));
            },
          ),
        ],
      ),
      body: const HistoryList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showConnectDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<bool?> _showOpenSettingsDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Permission Required"),
          content: const Text(
              "Storage permission is Required. Please enable it from app settings."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }
}
