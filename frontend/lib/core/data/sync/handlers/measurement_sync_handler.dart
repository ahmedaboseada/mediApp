import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/data/sync/sync_handler.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo.dart';

class MeasurementSyncHandler implements SyncHandler {
  final LogsRepo repo;

  MeasurementSyncHandler(this.repo);

  @override
  Future<Map<String, dynamic>?> handle(SyncAction action) async {
    final type = action.data['type'];
    final measurementType = action.data['type']?.toString() ?? '';

    switch (type) {
      case 'blood_pressure':
        final result = await repo.addBloodPressure(
          type: measurementType.isNotEmpty ? measurementType : 'blood_pressure',
          systolic: action.data['systolic'],
          diastolic: action.data['diastolic'],
          heartRate: action.data['heartRate'],
          persistLocal: false,
        );
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message},
        );
      case 'heart_rate':
        final result = await repo.addHeartRate(
          type: measurementType.isNotEmpty ? measurementType : 'heart_rate',
          value: action.data['value'],
          persistLocal: false,
        );
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message},
        );
      case 'blood_sugar':
        final result = await repo.addBloodSugar(
          type: measurementType.isNotEmpty ? measurementType : 'blood_sugar',
          value: action.data['value'],
          notes: action.data['notes']?.toString(),
          persistLocal: false,
        );
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message},
        );
      case 'weight':
        final result = await repo.addWeight(
          type: measurementType.isNotEmpty ? measurementType : 'weight',
          value: (action.data['value'] as num).toDouble(),
          persistLocal: false,
        );
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message},
        );
      default:
        throw Exception('Unknown measurement type: $type');
    }
  }
}
