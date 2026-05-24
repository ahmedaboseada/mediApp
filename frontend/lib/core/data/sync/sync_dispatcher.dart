import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/data/sync/models/sync_entity.dart';
import 'package:medi/core/data/sync/sync_handler.dart';

class SyncDispatcher {
  final Map<SyncEntity, SyncHandler> handlers;

  SyncDispatcher({required this.handlers});

  Future<Map<String, dynamic>?> dispatch(SyncAction action) async {
    final handler = handlers[action.entity];
    if (handler == null) {
      throw Exception('Unknown entity: ${action.entity.name}');
    }
    return handler.handle(action);
  }
}
