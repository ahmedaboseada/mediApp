import 'package:uuid/uuid.dart';
import 'package:medi/core/services/hive_box_manager.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/core/data/sync/sync_service.dart';

class MedicationLocalDataSource {
  final HiveBoxManager boxManager;
  static const String _medicationsBox = 'medicationsBox';

  MedicationLocalDataSource({HiveBoxManager? boxManager}) : boxManager = boxManager ?? const HiveBoxManager();

  Future<List<Medication>> getMedications(String currentMedicationsKey) async {
    try {
      final box = await boxManager.openBox(_medicationsBox);
      final raw = box.get(currentMedicationsKey);
      if (raw == null) return [];
      return (raw as List).map((e) => Medication.fromJson(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveMedications(String currentMedicationsKey, List<Medication> medications) async {
    final box = await boxManager.openBox(_medicationsBox);
    await box.put(currentMedicationsKey, medications.map((m) => m.toJson()).toList());
  }

  Future<void> addMedication(String currentMedicationsKey, Medication medication) async {
    var med = medication;
    if (med.id.isEmpty) med = med.copyWith(id: const Uuid().v4());
    med = med.copyWith(isSynced: false);

    final current = await getMedications(currentMedicationsKey);
    current.add(med);
    await saveMedications(currentMedicationsKey, current);

    await SyncService.addToQueue(type: 'add', entity: 'medication', data: med.toJson());
  }

  Future<void> updateMedication(String currentMedicationsKey, {required Medication original, required Medication updated}) async {
    final current = await getMedications(currentMedicationsKey);
    var index = current.indexWhere((m) => m == original);
    if (index == -1) {
      index = current.indexWhere(
        (m) =>
            m.name == original.name &&
            m.type == original.type &&
            m.dosage == original.dosage &&
            m.startDate == original.startDate &&
            m.endDate == original.endDate,
      );
    }

    final medicationToSync = updated.copyWith(isSynced: false);

    if (index == -1) {
      current.add(medicationToSync);
    } else {
      current[index] = medicationToSync;
    }

    await saveMedications(currentMedicationsKey, current);

    await SyncService.addToQueue(type: 'update', entity: 'medication', data: medicationToSync.toJson());
  }

  Future<void> deleteMedication(String currentMedicationsKey, Medication medication) async {
    final current = await getMedications(currentMedicationsKey);
    var index = current.indexWhere((m) => m == medication);

    if (index == -1) {
      index = current.indexWhere(
        (m) =>
            m.name == medication.name &&
            m.type == medication.type &&
            m.dosage == medication.dosage &&
            m.startDate == medication.startDate &&
            m.endDate == medication.endDate,
      );
    }
    if (index != -1) {
      current.removeAt(index);
      await saveMedications(currentMedicationsKey, current);

      await SyncService.addToQueue(type: 'delete', entity: 'medication', data: medication.toJson());
    }
  }

  Future<void> markMedicationSynced(String currentMedicationsKey, String id) async {
    final current = await getMedications(currentMedicationsKey);
    final index = current.indexWhere((m) => m.id == id);
    if (index != -1) {
      current[index] = current[index].copyWith(isSynced: true);
      await saveMedications(currentMedicationsKey, current);
    }
  }

  Future<void> updateMedicationServerId(String currentMedicationsKey, String tempId, String serverId) async {
    final current = await getMedications(currentMedicationsKey);
    final index = current.indexWhere((m) => m.id == tempId);
    if (index != -1) {
      current[index] = current[index].copyWith(id: serverId, isSynced: true);
      await saveMedications(currentMedicationsKey, current);
    }
  }
}
