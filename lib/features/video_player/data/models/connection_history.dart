import 'package:hive/hive.dart';
part 'connection_history.g.dart';

@HiveType(typeId: 1)
class ConnectionHistory extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final DateTime connectedAt;

  @HiveField(3)
  final String protocol;

  @HiveField(4)
  final String ip;

  @HiveField(5)
  final int port;

  @HiveField(6)
  final String status;

  @HiveField(7)
  final DateTime addedAt;

  ConnectionHistory({
    required this.name,
    required this.url,
    required this.connectedAt,
    required this.protocol,
    required this.ip,
    required this.port,
    required this.status,
    required this.addedAt,
  });
  ConnectionHistory copyWith({
    String? name,
    String? url,
    DateTime? connectedAt,
    String? protocol,
    String? ip,
    int? port,
    String? status,
    DateTime? addedAt,
  }) {
    return ConnectionHistory(
      name: name ?? this.name,
      url: url ?? this.url,
      connectedAt: connectedAt ?? this.connectedAt,
      protocol: protocol ?? this.protocol,
      ip: ip ?? this.ip,
      port: port ?? this.port,
      status: status ?? this.status,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  /// Returns how long ago the connection was added (e.g., "5 minutes ago")
  String get timeAgo {
    final duration = DateTime.now().difference(addedAt);
    if (duration.inDays > 0) return '${duration.inDays} day(s) ago';
    if (duration.inHours > 0) return '${duration.inHours} hour(s) ago';
    if (duration.inMinutes > 0) return '${duration.inMinutes} minute(s) ago';
    return 'Just now';
  }
}
