import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/connection_history.dart';

class ConnectionHistoryRepository {
  static final ConnectionHistoryRepository _instance =
  ConnectionHistoryRepository._internal();

  factory ConnectionHistoryRepository() => _instance;

  ConnectionHistoryRepository._internal();

  static const _boxName = 'connections';

  late Box<ConnectionHistory> _box;

  /// Initialize Hive and open the box
  Future<void> init() async {
    Hive.registerAdapter(ConnectionHistoryAdapter());
    _box = await Hive.openBox<ConnectionHistory>(_boxName);
  }

  /// Add a new connection entry
  Future<void> addConnection(ConnectionHistory history) async {
    await _box.add(history);
  }

  /// Get all connection entries
  List<ConnectionHistory> getAllConnections() {
    return _box.values.toList();
  }

  /// Delete a connection by key
  Future<void> deleteConnection(int key) async {
    await _box.delete(key);
  }

  /// Clear all connection history
  Future<void> clearAll() async {
    await _box.clear();
  }

  /// Update a connection by key
  Future<void> updateConnection(int key, ConnectionHistory updated) async {
    await _box.put(key, updated);
  }

  /// Get a specific connection by key
  ConnectionHistory? getConnection(int key) {
    return _box.get(key);
  }

  /// Listen to changes in the connection box
  Stream<BoxEvent> watch() {
    return _box.watch();
  }

  /// in ConnectionHistoryRepository.dart
  Stream<List<ConnectionHistory>> watchAllConnections() async* {
    yield _box.values.toList();
    yield* _box.watch().map((_) => _box.values.toList());
  }
}
