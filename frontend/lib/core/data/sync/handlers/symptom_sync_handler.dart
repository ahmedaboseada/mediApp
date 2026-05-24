import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/data/sync/sync_handler.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo.dart';

class SymptomSyncHandler implements SyncHandler {
  final LogsRepo repo;

  SymptomSyncHandler(this.repo);

  @override
  Future<Map<String, dynamic>?> handle(SyncAction action) async {
    final result = await repo.addSymptomLog(
      symptoms: List<String>.from(action.data['symptoms'] ?? const <String>[]),
      severity: action.data['severity']?.toString() ?? 'mild',
      notes: action.data['notes']?.toString() ?? '',
      persistLocal: false,
    );
    return result.fold(
      (error) => throw Exception(error.message),
      (message) => {'success': true, 'message': message},
    );
  }
}
