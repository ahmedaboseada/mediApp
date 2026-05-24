import 'package:medi/core/data/sync/handlers/measurement_sync_handler.dart';
import 'package:medi/core/data/sync/handlers/medication_sync_handler.dart';
import 'package:medi/core/data/sync/handlers/symptom_sync_handler.dart';
import 'package:medi/core/data/sync/models/sync_entity.dart';
import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/data/sync/sync_connectivity_service.dart';
import 'package:medi/core/data/sync/sync_dispatcher.dart';
import 'package:medi/core/data/sync/sync_processor.dart';
import 'package:medi/core/data/sync/sync_queue_manager.dart';
import 'package:medi/core/services/hive_service.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo.dart';

/// Backward-compatible facade that preserves existing call sites.
/// Internals are delegated to instance-based sync components.
class SyncService {
  static final SyncQueueManager _queueManager = SyncQueueManager();
  static final SyncConnectivityService _connectivityService =
      SyncConnectivityService();

  static SyncProcessor? _processor;

  static Future<void> init({
    required MedicineRepo medicineRepo,
    required LogsRepo logsRepo,
  }) async {
    final dispatcher = SyncDispatcher(
      handlers: {
        SyncEntity.medication: MedicationSyncHandler(medicineRepo),
        SyncEntity.measurement: MeasurementSyncHandler(logsRepo),
        SyncEntity.symptom: SymptomSyncHandler(logsRepo),
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
    final shouldAdd = await _queueManager.optimizeQueue(action);
    if (!shouldAdd) return;

    await _queueManager.addAction(action);
    await processQueue();
  }

  static List<SyncAction> getPendingActions() => _queueManager.getQueuedActions();

  static Future<void> processQueue() async {
    final processor = _processor;
    if (processor == null) return;
    await processor.processQueue();
  }
}
