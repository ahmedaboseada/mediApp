import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'models/sync_action_type.dart';
import 'models/sync_entity.dart';

class SyncAction extends HiveObject {
  final String id;
  final SyncActionType type;
  final SyncEntity entity;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  int retryCount;

  SyncAction({
    String? id,
    Object? type,
    Object? entity,
    required this.data,
    DateTime? createdAt,
    this.retryCount = 0,
  })  : id = id ?? const Uuid().v4(),
        type = SyncActionTypeX.fromAny(type),
        entity = SyncEntityX.fromAny(entity),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.storageValue,
      'entity': entity.storageValue,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
    };
  }

  factory SyncAction.fromJson(Map<String, dynamic> json) {
    return SyncAction(
      id: json['id'],
      type: json['type'],
      entity: json['entity'],
      data: Map<String, dynamic>.from(json['data']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: json['retryCount'] as int? ?? 0,
    );
  }
}

class SyncActionAdapter extends TypeAdapter<SyncAction> {
  @override
  final int typeId = 10;

  @override
  SyncAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncAction(
      id: fields[0] as String?,
      type: fields[1] as String?,
      entity: fields[2] as String?,
      data: (fields[3] as Map).cast<String, dynamic>(),
      createdAt: fields[4] as DateTime?,
      retryCount: fields[5] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, SyncAction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type.storageValue)
      ..writeByte(2)
      ..write(obj.entity.storageValue)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.retryCount);
  }
}
