import 'package:medi/core/data/sync/models/sync_action_type.dart';
import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/data/sync/sync_handler.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';

class BookingSyncHandler implements SyncHandler {
  final DoctorsRepository repo;

  BookingSyncHandler(this.repo);

  @override
  Future<Map<String, dynamic>?> handle(SyncAction action) async {
    final type = action.type.storageValue ;

    switch (type) {
      case 'add':
        final result = await repo.createBooking(Map<String, dynamic>.from(action.data));
        return result.fold((err) => throw Exception(err.message), (res) => {'success': true});
      case 'update':
        // expected payload: { id, ...fields }
        final id = (action.data['id'] ?? action.data['_id'])?.toString() ?? '';
        if (id.isEmpty) throw Exception('Missing booking id');
        final result = await repo.rescheduleBooking(id, action.data['date']?.toString() ?? '', action.data['time']?.toString() ?? '');
        return result.fold((err) => throw Exception(err.message), (_) => {'success': true});
      case 'delete':
        final id = (action.data['id'] ?? action.data['_id'])?.toString() ?? '';
        final reason = action.data['cancelledReason']?.toString() ?? action.data['reason']?.toString() ?? '';
        if (id.isEmpty) throw Exception('Missing booking id');
        final result = await repo.cancelBooking(id, reason);
        return result.fold((err) => throw Exception(err.message), (_) => {'success': true});
      default:
        throw Exception('Unknown booking action type: $type');
    }
  }
}
