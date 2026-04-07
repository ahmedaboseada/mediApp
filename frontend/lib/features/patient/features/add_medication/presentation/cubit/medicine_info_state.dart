import 'package:equatable/equatable.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

class MedicineInfoState extends Equatable {
  const MedicineInfoState({
    required this.medication,
    required this.isDeleted,
    required this.isTaken,
    required this.scheduleTimes,
    required this.nextScheduleTime,
  });

  factory MedicineInfoState.initial() {
    return const MedicineInfoState(
      medication: Medication(),
      isDeleted: false,
      isTaken: false,
      scheduleTimes: <MedicationScheduleTime>[],
      nextScheduleTime: '',
    );
  }

  factory MedicineInfoState.fromMedication(Medication medication) {
    return MedicineInfoState(
      medication: medication,
      isDeleted: false,
      isTaken: false,
      scheduleTimes: <MedicationScheduleTime>[],
      nextScheduleTime: '',
    );
  }

  final Medication medication;
  final bool isDeleted;
  final bool isTaken;
  final List<MedicationScheduleTime> scheduleTimes;
  final String nextScheduleTime;

  String get medicineName => medication.name;

  String get medicineSubtitle {
    final subtitleParts = ' ${medication.stock} units';

    return subtitleParts;
  }

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

  String get frequency => medication.frequency.trim();

  String get duration => medication.endDate.trim();

  List<String> get sideEffects => const <String>[];

  String get notes => '';

  MedicineInfoState copyWith({
    Medication? medication,
    bool? isDeleted,
    bool? isTaken,
    List<MedicationScheduleTime>? scheduleTimes,
    String? nextScheduleTime,
  }) {
    return MedicineInfoState(
      medication: medication ?? this.medication,
      isDeleted: isDeleted ?? this.isDeleted,
      isTaken: isTaken ?? this.isTaken,
      scheduleTimes: scheduleTimes ?? this.scheduleTimes,
      nextScheduleTime: nextScheduleTime ?? this.nextScheduleTime,
    );
  }

  @override
  List<Object?> get props => [
    medication,
    isDeleted,
    isTaken,
    scheduleTimes,
    nextScheduleTime,
  ];
}
