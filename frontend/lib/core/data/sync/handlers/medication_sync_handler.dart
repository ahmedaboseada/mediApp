import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/data/sync/models/sync_action_type.dart';
import 'package:medi/core/data/sync/sync_handler.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';

class MedicationSyncHandler implements SyncHandler {
  final MedicineRepo repo;

  MedicationSyncHandler(this.repo);

  @override
  Future<Map<String, dynamic>?> handle(SyncAction action) async {
    if (action.type == SyncActionType.markAsTaken) {
      final medicationId = (action.data['id'] ?? action.data['_id'])?.toString();
      final result = await repo.markAsTaken(
        medicationId: medicationId ?? '',
        date: action.data['date']?.toString() ?? '',
        time: action.data['time']?.toString() ?? '',
        taken: action.data['taken'] ?? true,
      );
      return result.fold(
        (error) => throw Exception(error.message),
        (message) => {'success': true, 'message': message},
      );
    }

    final medication = Medication.fromJson(action.data);

    switch (action.type) {
      case SyncActionType.add:
        final result = await repo.addMedicineFromMedication(medication);
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message, 'id': medication.id},
        );
      case SyncActionType.update:
        final result = await repo.updateMedicineFromMedication(
          medicationId: medication.id,
          medication: medication,
        );
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message},
        );
      case SyncActionType.delete:
        final id = (action.data['id'] ?? action.data['_id'])?.toString() ?? '';
        final result = await repo.deleteMedication(medicationId: id);
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message, 'deleted': true},
        );
      case SyncActionType.markAsTaken:
        // handled above
        return null;
    }
  }
}
