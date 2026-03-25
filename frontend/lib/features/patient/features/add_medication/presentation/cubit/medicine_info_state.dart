import 'package:equatable/equatable.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

class MedicineInfoState extends Equatable {
  const MedicineInfoState({required this.medication, required this.isDeleted});

  factory MedicineInfoState.initial() {
    return const MedicineInfoState(medication: Medication(), isDeleted: false);
  }

  factory MedicineInfoState.fromMedication(Medication medication) {
    return MedicineInfoState(medication: medication, isDeleted: false);
  }

  final Medication medication;
  final bool isDeleted;

  String get medicineName => medication.name;

  String get medicineSubtitle {
    final subtitleParts = ' ${medication.stock} units';

    return subtitleParts;
  }

  bool get isTaken => medication.isActive;

  MedicationType get medicationType => medication.resolvedMedicationType;

  bool get criticalMode => medication.isCriticalMode;

  int get stock => medication.stock;

  String get expiryDate =>
      medication.expiryDate.isNotEmpty ? medication.expiryDate : 'N/A';

  List<String> get reminders {
    final reminderTimes = medication.reminders
        .expand(
          (entry) => entry
              .split(RegExp(r'[,\n]'))
              .map((time) => time.trim())
              .where((time) => time.isNotEmpty),
        )
        .toList();

    if (reminderTimes.isNotEmpty) {
      return reminderTimes;
    }

    return medication.schedule
        .split(RegExp(r'[,\n]'))
        .map((time) => time.trim())
        .where((time) => time.isNotEmpty)
        .toList();
  }

  String get frequency => medication.frequency.trim().isNotEmpty
      ? medication.frequency.trim()
      : 'Daily';

  String get duration => medication.endDate.trim().isNotEmpty
      ? medication.endDate.trim()
      : 'Ongoing';

  List<String> get sideEffects => const [
    'Hypoglycemia',
    'Weight gain',
    'Injection site reaction',
  ];

  String get notes => 'Take before meals. Monitor blood sugar levels closely.';

  MedicineInfoState copyWith({Medication? medication, bool? isDeleted}) {
    return MedicineInfoState(
      medication: medication ?? this.medication,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [medication, isDeleted];
}
