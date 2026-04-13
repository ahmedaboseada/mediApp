import 'package:hive/hive.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/shared/auth/data/models/caregiver_model.dart';

part 'patient_model.g.dart';

@HiveType(typeId: 1)
class PatientModel {
  @HiveField(0)
  final String patientId;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final List<String> chronicConditions;
  @HiveField(3)
  final List<String> allergies;
  @HiveField(4)
  final List<String> activeIngredients;
  @HiveField(5)
  final List<String> longTermMedication;
  @HiveField(6)
  final List<Medication> medications;
  @HiveField(7)
  final bool saveOption;
  @HiveField(8)
  final List<String> connectedDoctors;
  @HiveField(9)
  final String createdAt;
  @HiveField(10)
  final String updatedAt;
  @HiveField(11)
  final bool allergyAlerts;
  @HiveField(12)
  final bool reactionToMedication;
  @HiveField(13)
  final CaregiverModel? caregiver;

  PatientModel({
    required this.patientId,
    required this.userId,
    required this.chronicConditions,
    required this.allergies,
    required this.activeIngredients,
    required this.longTermMedication,
    required this.medications,
    required this.saveOption,
    required this.connectedDoctors,
    required this.createdAt,
    required this.updatedAt,
    required this.allergyAlerts,
    required this.reactionToMedication,
    this.caregiver,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(dynamic value) {
      if (value is! List) {
        return const [];
      }

      return value
          .map((item) {
            if (item is String) {
              return item;
            }

            if (item is Map<String, dynamic>) {
              final name = item['name'];
              if (name != null) {
                return name.toString();
              }

              final id = item['_id'] ?? item['id'];
              if (id != null) {
                return id.toString();
              }
            }

            return item?.toString();
          })
          .whereType<String>()
          .toList();
    }

    return PatientModel(
      patientId: (json['_id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      chronicConditions: parseStringList(json['chronicConditions']),
      allergies: parseStringList(json['allergies']),
      activeIngredients: parseStringList(json['activeIngredients']),
      longTermMedication: parseStringList(json['longTermMedication']),
      medications: List<Medication>.from(
        (json['medications'] as List? ?? []).map(
          (e) => Medication.fromJson(e as Map<String, dynamic>),
        ),
      ),
      saveOption: json['saveOption'] as bool? ?? false,
      connectedDoctors: parseStringList(json['connectedDoctors']),
      createdAt: (json['createdAt'] ?? '').toString(),
      updatedAt: (json['updatedAt'] ?? '').toString(),
      allergyAlerts: json['allergyAlerts'] as bool? ?? false,
      reactionToMedication: json['reactionToMedication'] as bool? ?? false,
      caregiver: json['caregiver'] != null
          ? CaregiverModel.fromJson(json['caregiver'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': patientId,
      'userId': userId,
      'chronicConditions': chronicConditions,
      'allergies': allergies,
      'activeIngredients': activeIngredients,
      'longTermMedication': longTermMedication,
      'medications': medications.map((m) => m.toJson()).toList(),
      'saveOption': saveOption,
      'connectedDoctors': connectedDoctors,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'allergyAlerts': allergyAlerts,
      'reactionToMedication': reactionToMedication,
      if (caregiver != null) 'caregiver': caregiver!.toJson(),
    };
  }
}
