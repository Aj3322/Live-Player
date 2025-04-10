import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:live_stream_pilot/features/video_player/data/repositories/recording_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/video_player/data/repositories/connection_history_repository.dart';
import 'features/video_player/presentation/widgets/pip_overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await VideoRecordingRepository().init();
  await ConnectionHistoryRepository().init();
  runApp(
  const ProviderScope(
      child: AeroVisionApp(),
    ),
  );
}
@pragma("vm:entry-point")
void overlayMain() {
  runApp( ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: VideoOverlay()),
      ),
    ),
  ));
}

class AeroVisionApp extends StatelessWidget {
  const AeroVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Live Player',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}