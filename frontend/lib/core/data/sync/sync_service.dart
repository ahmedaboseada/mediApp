import 'package:medi/core/data/sync/handlers/measurement_sync_handler.dart';
import 'package:medi/core/data/sync/handlers/medication_sync_handler.dart';
import 'package:medi/core/data/sync/handlers/symptom_sync_handler.dart';
import 'package:medi/core/data/sync/handlers/booking_sync_handler.dart';
import 'package:medi/core/data/sync/handlers/profile_sync_handler.dart';
import 'package:medi/core/data/sync/handlers/doctor_schedule_sync_handler.dart';
import 'package:medi/core/data/sync/handlers/two_factor_sync_handler.dart';
import 'package:medi/core/data/sync/models/sync_entity.dart';
import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/data/sync/sync_connectivity_service.dart';
import 'package:medi/core/data/sync/sync_dispatcher.dart';
import 'package:medi/core/data/sync/sync_processor.dart';
import 'package:medi/core/data/sync/sync_queue_manager.dart';
import 'package:medi/core/services/hive_service.dart';
import 'package:medi/core/network/api_service.dart';
import 'package:medi/core/services/app_logger.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';

/// Backward-compatible facade that preserves existing call sites.
/// Internals are delegated to instance-based sync components.
class SyncService {
  static final SyncQueueManager _queueManager = SyncQueueManager();
  static final SyncConnectivityService _connectivityService =
      SyncConnectivityService();

  static SyncProcessor? _processor;

  static Future<void> init({
    required ApiService apiService,
    required MedicineRepo medicineRepo,
    required LogsRepo logsRepo,
    required DoctorsRepository doctorsRepo,
  }) async {
    final dispatcher = SyncDispatcher(
      handlers: {
        SyncEntity.medication: MedicationSyncHandler(medicineRepo),
        SyncEntity.measurement: MeasurementSyncHandler(logsRepo),
        SyncEntity.symptom: SymptomSyncHandler(logsRepo),
        SyncEntity.booking: BookingSyncHandler(doctorsRepo),
        SyncEntity.profile: ProfileSyncHandler(apiService),
        SyncEntity.doctorSchedule: DoctorScheduleSyncHandler(apiService),
        SyncEntity.twoFactor: TwoFactorSyncHandler(apiService),
      },
    );

    _processor = SyncProcessor(
      queueManager: _queueManager,
      dispatcher: dispatcher,
      connectivityService: _connectivityService,
      markSynced: (entity, id) async {
        if (entity == SyncEntity.medication.name) {
          await HiveService.markMedicationSynced(id ?? '');
        }
      },
      updateLocalId: (entity, tempId, serverId) async {
        if (entity == SyncEntity.medication.name) {
          await HiveService.updateMedicationServerId(tempId, serverId);
        }
      },
      markScheduleTaken: ({
        required String date,
        required String medicationId,
        required String time,
        required bool taken,
      }) async {
        await HiveService.markMedicationScheduleTaken(
          date: date,
          medicationId: medicationId,
          time: time,
          taken: taken,
        );
      },
    );
  }

  static Future<void> addToQueue({
    required Object type,
    required Object entity,
    required Map<String, dynamic> data,
  }) async {
    final action = SyncAction(type: type, entity: entity, data: data);
    AppLogger.instance.i('Enqueueing sync action: ${action.type} ${action.entity} id=${action.data["id"] ?? action.data["_id"]}');
    final shouldAdd = await _queueManager.optimizeQueue(action);
    if (!shouldAdd) {
      AppLogger.instance.i('Optimize prevented enqueue: ${action.type} ${action.entity}');
      return;
    }

    await _queueManager.addAction(action);
    AppLogger.instance.i('Action stored in queue: ${action.id}');
    await processQueue();
  }

  static Future<List<SyncAction>> getPendingActions() => _queueManager.getQueuedActions();

  static Future<void> processQueue() async {
    final processor = _processor;
    if (processor == null) return;
    await processor.processQueue();
  }
}
