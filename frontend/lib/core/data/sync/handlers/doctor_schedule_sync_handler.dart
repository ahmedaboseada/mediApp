import 'package:medi/core/data/sync/models/sync_action_type.dart';
import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/data/sync/sync_handler.dart';
import 'package:medi/core/network/api_service.dart';
import 'package:medi/core/network/api_exceptions.dart';

class DoctorScheduleSyncHandler implements SyncHandler {
  DoctorScheduleSyncHandler(this.apiService);

  final ApiService apiService;

  @override
  Future<Map<String, dynamic>?> handle(SyncAction action) async {
    if (action.type != SyncActionType.update) {
      throw Exception('Unsupported doctor schedule sync action: ${action.type.storageValue}');
    }

    final payload = Map<String, dynamic>.from(action.data)
      ..remove('id')
      ..remove('_id');

    final response = await apiService.patch(
      '/doctors/schedule',
      payload,
      headers: {'Content-Type': 'application/json'},
    );

    if (response is ServerFailure) {
      throw Exception(response.message);
    }

    return {'success': true};
  }
}
