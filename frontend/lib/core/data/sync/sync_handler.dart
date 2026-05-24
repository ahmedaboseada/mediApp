import 'package:medi/core/data/sync/sync_action.dart';

abstract class SyncHandler {
  Future<Map<String, dynamic>?> handle(SyncAction action);
}
