import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/core/data/sync/sync_action.dart';
import 'package:medi/core/services/hive_service.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo.dart';

class SyncService {
  static const String _syncBoxName = 'syncBox';
  static Completer<void>? _syncCompleter;
  static MedicineRepo? _medicineRepo;
  static LogsRepo? _logsRepo;

  /// Initialize the sync service and box
  static Future<void> init({
    required MedicineRepo medicineRepo,
    required LogsRepo logsRepo,
  }) async {
    _medicineRepo = medicineRepo;
    _logsRepo = logsRepo;
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(SyncActionAdapter());
    }
    await _openBox();
  }

  static Future<Box<SyncAction>> _openBox() async {
    if (!Hive.isBoxOpen(_syncBoxName)) {
      return await Hive.openBox<SyncAction>(_syncBoxName);
    }
    return Hive.box<SyncAction>(_syncBoxName);
  }

  /// Add a new action to the sync queue
  static Future<void> addToQueue({
    required String type,
    required String entity,
    required Map<String, dynamic> data,
  }) async {
    final box = await _openBox();
    final action = SyncAction(type: type, entity: entity, data: data);

    // Optimize queue before adding
    final shouldAdd = await _optimizeQueue(action);
    if (!shouldAdd) return;

    await box.add(action);

    // Trigger sync if online
    processQueue();
  }

  /// Get all pending actions from the queue
  static List<SyncAction> getPendingActions() {
    if (!Hive.isBoxOpen(_syncBoxName)) return [];
    final box = Hive.box<SyncAction>(_syncBoxName);
    return box.values.toList();
  }

  /// Optimize the queue to remove redundant operations
  static Future<bool> _optimizeQueue(SyncAction newAction) async {
    final box = Hive.box<SyncAction>(_syncBoxName);
    final pendingActions = box.values.toList();
    final entityId = newAction.data['id'] ?? newAction.data['_id'];

    if (newAction.type == 'delete') {
      // Find any previous actions for the same entity
      for (int i = pendingActions.length - 1; i >= 0; i--) {
        final a = pendingActions[i];
        final aId = a.data['id'] ?? a.data['_id'];

        if (a.entity == newAction.entity && aId == entityId) {
          if (a.type == 'add') {
            // If it was added then deleted before sync, remove the 'add' and don't add the 'delete'
            await box.deleteAt(i);
            return false;
          } else {
            // Remove previous updates if we are deleting
            await box.deleteAt(i);
          }
        }
      }
    } else if (newAction.type == 'update') {
      // Ensure no duplicate updates for same entity id
      for (int i = pendingActions.length - 1; i >= 0; i--) {
        final a = pendingActions[i];
        final aId = a.data['id'] ?? a.data['_id'];

        if (a.entity == newAction.entity &&
            aId == entityId &&
            a.type == 'update') {
          await box.deleteAt(i);
        }
      }
    }
    return true;
  }

  /// Check if there is real internet access
  static Future<bool> _hasRealInternet() async {
    try {
      final results = await Connectivity().checkConnectivity();
      if (results.any((r) => r == ConnectivityResult.none)) return false;

      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Process the pending actions in the queue sequentially
  static Future<void> processQueue() async {
    // Prevent concurrent sync processes
    if (_syncCompleter != null && !_syncCompleter!.isCompleted) return;

    if (!await _hasRealInternet()) return;

    _syncCompleter = Completer<void>();
    final box = await _openBox();

    print('Starting sync queue processing... (${box.length} actions)');

    while (box.isNotEmpty) {
      final key = box.keyAt(0);
      final action = box.get(key);

      if (action == null) {
        await box.delete(key);
        continue;
      }

      final serverResponse = await _sendToApi(action);

      if (serverResponse != null) {
        // Success: Handle ID mapping if it was an 'add'
        if (action.type == 'add') {
          final tempId = action.data['id'] ?? action.data['_id'];
          final serverId = serverResponse['id'] ?? serverResponse['_id'];

          if (tempId != null && serverId != null) {
            await _updateLocalId(action.entity, tempId, serverId);
          }
        } else {
          // For updates/deletes, just mark as synced locally
          await _markSynced(
            action.entity,
            action.data['id'] ?? action.data['_id'],
          );
        }

        // Remove from queue safely using key
        await box.delete(key);
      } else {
        // Failure: Increment retry count
        action.retryCount++;
        if (action.retryCount >= 3) {
          print('Action ${action.id} failed after 3 retries. Dropping.');
          await box.delete(key);
        } else {
          await action.save();
          print(
            'Action ${action.id} failed. Retry count: ${action.retryCount}. Stopping queue.',
          );
          break; // Stop processing to maintain order
        }
      }
    }

    _syncCompleter?.complete();
    _syncCompleter = null;
  }

  /// Mark local item as synced
  static Future<void> _markSynced(String entity, String? id) async {
    if (id == null) return;
    if (entity == 'medication') {
      await HiveService.markMedicationSynced(id);
    }
    // TODO: Add for other entities
  }

  /// Update local item ID with the one returned from server
  static Future<void> _updateLocalId(
    String entity,
    String tempId,
    String serverId,
  ) async {
    if (entity == 'medication') {
      await HiveService.updateMedicationServerId(tempId, serverId);
    }
    // TODO: Add for other entities
  }

  /// Repository-based API handler
  static Future<Map<String, dynamic>?> _sendToApi(SyncAction action) async {
    try {
      if (_medicineRepo == null || _logsRepo == null) {
        throw Exception("Repositories not initialized");
      }

      Map<String, dynamic>? result;

      switch (action.entity) {
        case 'medication':
          result = await _handleMedication(action);
          break;

        case 'measurement':
          result = await _handleMeasurement(action);
          break;

        case 'symptom':
          result = await _handleSymptom(action);
          break;

        default:
          throw Exception('Unknown entity: ${action.entity}');
      }

      print('SYNC SUCCESS: ${action.type} ${action.entity}');
      return result;
    } catch (e) {
      print('SYNC ERROR: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _handleMedication(
    SyncAction action,
  ) async {
    final repo = _medicineRepo!;

    if (action.type == 'mark_as_taken') {
      final result = await repo.markAsTaken(
        medicationId: action.data['id'] ?? action.data['_id'],
        date: action.data['date'],
        time: action.data['time'],
        taken: action.data['taken'] ?? true,
      );
      return result.fold(
        (error) => throw Exception(error.message),
        (message) => {'success': true, 'message': message},
      );
    }

    final medication = Medication.fromJson(action.data);

    switch (action.type) {
      case 'add':
        final result = await repo.addMedicineFromMedication(medication);
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {
            'success': true,
            'message': message,
            'id': medication.id,
          },
        );

      case 'update':
        final result = await repo.updateMedicineFromMedication(
          medicationId: medication.id,
          medication: medication,
        );
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message},
        );

      case 'delete':
        final id = action.data['id'] ?? action.data['_id'];
        final result = await repo.deleteMedication(medicationId: id);
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message, 'deleted': true},
        );

      default:
        throw Exception('Unknown action type');
    }
  }

  static Future<Map<String, dynamic>?> _handleMeasurement(
    SyncAction action,
  ) async {
    final repo = _logsRepo!;
    final type =
        action.data['type']; // e.g. "blood_pressure", "heart_rate", etc.

    switch (type) {
      case 'blood_pressure':
        final result = await repo.addBloodPressure(
          type: action.data['measurementType'] ?? 'manual',
          systolic: action.data['systolic'],
          diastolic: action.data['diastolic'],
          heartRate: action.data['heartRate'],
        );
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message},
        );
      case 'heart_rate':
        final result = await repo.addHeartRate(
          type: action.data['measurementType'] ?? 'manual',
          value: action.data['value'],
        );
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message},
        );
      case 'blood_sugar':
        final result = await repo.addBloodSugar(
          type: action.data['measurementType'] ?? 'manual',
          value: action.data['value'],
          notes: action.data['notes'],
        );
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message},
        );
      case 'weight':
        final result = await repo.addWeight(
          type: action.data['measurementType'] ?? 'manual',
          value: (action.data['value'] as num).toDouble(),
        );
        return result.fold(
          (error) => throw Exception(error.message),
          (message) => {'success': true, 'message': message},
        );
      default:
        throw Exception('Unknown measurement type: $type');
    }
  }

  static Future<Map<String, dynamic>?> _handleSymptom(SyncAction action) async {
    final repo = _logsRepo!;
    final result = await repo.addSymptomLog(
      symptoms: List<String>.from(action.data['symptoms'] ?? []),
      severity: action.data['severity'] ?? 'mild',
      notes: action.data['notes'] ?? '',
    );
    return result.fold(
      (error) => throw Exception(error.message),
      (message) => {'success': true, 'message': message},
    );
  }
}
