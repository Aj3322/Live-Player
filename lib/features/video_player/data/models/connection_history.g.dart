// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConnectionHistoryAdapter extends TypeAdapter<ConnectionHistory> {
  @override
  final int typeId = 1;

  @override
  ConnectionHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConnectionHistory(
      name: fields[0] as String,
      url: fields[1] as String,
      connectedAt: fields[2] as DateTime,
      protocol: fields[3] as String,
      ip: fields[4] as String,
      port: fields[5] as int,
      status: fields[6] as String,
      addedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ConnectionHistory obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.connectedAt)
      ..writeByte(3)
      ..write(obj.protocol)
      ..writeByte(4)
      ..write(obj.ip)
      ..writeByte(5)
      ..write(obj.port)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectionHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
