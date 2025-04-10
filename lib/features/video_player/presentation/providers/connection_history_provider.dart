// providers/connection_history_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/connection_history.dart';
import '../../data/repositories/connection_history_repository.dart';

final connectionHistoryProvider = StreamProvider<List<ConnectionHistory>>(
      (ref) => ConnectionHistoryRepository().watchAllConnections(),
);
