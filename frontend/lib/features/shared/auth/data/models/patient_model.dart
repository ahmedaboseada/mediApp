import 'package:hive/hive.dart';
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
  final List<String> medications;
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
    return PatientModel(
      patientId: (json['_id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      chronicConditions: List<String>.from(
        json['chronicConditions'] as List? ?? [],
      ),
      allergies: List<String>.from(json['allergies'] as List? ?? []),
      activeIngredients: List<String>.from(
        json['activeIngredients'] as List? ?? [],
      ),
      longTermMedication: List<String>.from(
        json['longTermMedication'] as List? ?? [],
      ),
      medications: List<String>.from(json['medications'] as List? ?? []),
      saveOption: json['saveOption'] as bool? ?? false,
      connectedDoctors: List<String>.from(
        json['connectedDoctors'] as List? ?? [],
      ),
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
      'medications': medications,
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
