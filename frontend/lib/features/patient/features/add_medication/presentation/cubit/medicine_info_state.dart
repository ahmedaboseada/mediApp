import 'package:equatable/equatable.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';

class ScheduleItem extends Equatable {
  const ScheduleItem({
    required this.id,
    required this.time,
    required this.frequency,
    required this.duration,
  });

  final String id;
  final String time;
  final String frequency;
  final String duration;

  @override
  List<Object?> get props => [id, time, frequency, duration];
}

enum FeedbackSeverity { severe, moderate, mild }

class FeedbackLogItem extends Equatable {
  const FeedbackLogItem({
    required this.id,
    required this.date,
    required this.description,
    required this.severity,
  });

  final String id;
  final String date;
  final String description;
  final FeedbackSeverity severity;

  @override
  List<Object?> get props => [id, date, description, severity];
}

class MedicineInfoState extends Equatable {
  const MedicineInfoState({
    required this.medicineName,
    required this.medicineSubtitle,
    required this.isTaken,
    required this.medicationType,
    required this.criticalMode,
    required this.stock,
    required this.expiryDate,
    required this.schedule,
    required this.sideEffects,
    required this.feedbackLogs,
    required this.notes,
    required this.isDeleted,
  });

  factory MedicineInfoState.initial() {
    return const MedicineInfoState(
      medicineName: 'Aspirin',
      medicineSubtitle: '10 unit',
      isTaken: true,
      medicationType: MedicationType.tablet,
      criticalMode: false,
      stock: 3,
      expiryDate: 'Jun 2026',
      schedule: [
        ScheduleItem(
          id: 's1',
          time: '8:00 PM',
          frequency: 'Daily',
          duration: 'Ongoing',
        ),
      ],
      sideEffects: ['Hypoglycemia', 'Weight gain', 'Injection site reaction'],
      feedbackLogs: [
        FeedbackLogItem(
          id: 'f1',
          date: '2026-01-11',
          description: 'Mild dizziness',
          severity: FeedbackSeverity.severe,
        ),
        FeedbackLogItem(
          id: 'f2',
          date: '2026-01-09',
          description: 'Site reaction',
          severity: FeedbackSeverity.moderate,
        ),
      ],
      notes: 'Take before meals. Monitor blood sugar levels closely.',
      isDeleted: false,
    );
  }

  factory MedicineInfoState.fromMedication(Medication medication) {
    final stockValue = int.tryParse(medication.currentStock) ?? 0;

    return MedicineInfoState(
      medicineName: medication.name,
      medicineSubtitle: '${medication.dosage} ${medication.type}',
      isTaken: false,
      medicationType: medication.medicationType,
      criticalMode: medication.isCriticalMode,
      stock: stockValue,
      expiryDate: medication.expiryDate.isNotEmpty
          ? medication.expiryDate
          : 'N/A',
      schedule: medication.schedule.isNotEmpty
          ? [
              ScheduleItem(
                id: 's1',
                time: medication.schedule,
                frequency: medication.frequency,
                duration: 'Ongoing',
              ),
            ]
          : const [],
      sideEffects: const [],
      feedbackLogs: const [],
      notes: '',
      isDeleted: false,
    );
  }

  final String medicineName;
  final String medicineSubtitle;
  final bool isTaken;
  final MedicationType medicationType;
  final bool criticalMode;
  final int stock;
  final String expiryDate;
  final List<ScheduleItem> schedule;
  final List<String> sideEffects;
  final List<FeedbackLogItem> feedbackLogs;
  final String notes;
  final bool isDeleted;

  MedicineInfoState copyWith({
    String? medicineName,
    String? medicineSubtitle,
    bool? isTaken,
    MedicationType? medicationType,
    bool? criticalMode,
    int? stock,
    String? expiryDate,
    List<ScheduleItem>? schedule,
    List<String>? sideEffects,
    List<FeedbackLogItem>? feedbackLogs,
    String? notes,
    bool? isDeleted,
  }) {
    return MedicineInfoState(
      medicineName: medicineName ?? this.medicineName,
      medicineSubtitle: medicineSubtitle ?? this.medicineSubtitle,
      isTaken: isTaken ?? this.isTaken,
      medicationType: medicationType ?? this.medicationType,
      criticalMode: criticalMode ?? this.criticalMode,
      stock: stock ?? this.stock,
      expiryDate: expiryDate ?? this.expiryDate,
      schedule: schedule ?? this.schedule,
      sideEffects: sideEffects ?? this.sideEffects,
      feedbackLogs: feedbackLogs ?? this.feedbackLogs,
      notes: notes ?? this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
    medicineName,
    medicineSubtitle,
    isTaken,
    medicationType,
    criticalMode,
    stock,
    expiryDate,
    schedule,
    sideEffects,
    feedbackLogs,
    notes,
    isDeleted,
  ];
}
