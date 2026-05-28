import 'package:medi/core/data/sync/models/sync_action_type.dart';
import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/data/sync/sync_handler.dart';
import 'package:medi/core/network/api_service.dart';
import 'package:medi/core/network/api_exceptions.dart';

class TwoFactorSyncHandler implements SyncHandler {
  TwoFactorSyncHandler(this.apiService);

  final ApiService apiService;

  @override
  Future<Map<String, dynamic>?> handle(SyncAction action) async {
    if (action.type != SyncActionType.update) {
      throw Exception('Unsupported 2FA sync action: ${action.type.storageValue}');
    }

    final enabled = action.data['enabled'];
    if (enabled is! bool) {
      throw Exception('Invalid two-factor payload');
    }

    final response = await apiService.patch(
      '/users/2fa',
      {'enabled': enabled},
      headers: {'Content-Type': 'application/json'},
    );

    if (response is ServerFailure) {
      throw Exception(response.message);
    }

    return {'success': true};
  }
}
