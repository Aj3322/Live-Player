import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_stream_pilot/features/video_player/presentation/screens/history_screen.dart';
import 'package:live_stream_pilot/features/video_player/presentation/screens/home_screen.dart';
import 'package:live_stream_pilot/features/video_player/presentation/screens/recording_screen.dart';

import '../../features/video_player/data/repositories/recording_repository.dart';
import '../utils/permission.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>HomeScreen(),
    ),
    GoRoute(
        path: '/video-recorded',
      builder: (context, state) => RecordingsScreen()
    ),
    GoRoute(
        path: '/connection-history',
        builder: (context, state) => HistoryScreen()
    )
  ],
);

class AppRouter {
  static void push(BuildContext context, String route) {
    context.push(route);
  }

  static void pop(BuildContext context) {
    context.pop();
  }

  static void go(BuildContext context, String route) {
    context.go(route);
  }
}