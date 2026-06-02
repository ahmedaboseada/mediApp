import 'package:hive/hive.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/shared/auth/data/models/caregiver_model.dart';
import 'package:medi/features/shared/auth/data/models/emergency_contact_model.dart';

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
  @HiveField(14)
  final EmergencyContactModel? emergencyContact;

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
    this.emergencyContact,
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

            if (item is Map) {
              final mapItem = Map<String, dynamic>.from(item);
              final name = mapItem['name'];
              if (name != null) {
                return name.toString();
              }

              final id = mapItem['_id'] ?? mapItem['id'];
              if (id != null) {
                return id.toString();
              }
            }

            return item?.toString();
          })
          .whereType<String>()
          .toList();
    }

    Map<String, dynamic>? parseMap(dynamic value) {
      if (value is Map<String, dynamic>) {
        return value;
      }

      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }

      return null;
    }

    List<Medication> parseMedications(dynamic value) {
      if (value is! List) {
        return const [];
      }

      return value
          .whereType<Map>()
          .map((item) => Medication.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    return PatientModel(
      patientId: (json['_id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      chronicConditions: parseStringList(json['chronicConditions']),
      allergies: parseStringList(json['allergies']),
      activeIngredients: parseStringList(json['activeIngredients']),
      longTermMedication: parseStringList(json['longTermMedication']),
      medications: parseMedications(json['medications']),
      saveOption: json['saveOption'] as bool? ?? false,
      connectedDoctors: parseStringList(json['connectedDoctors']),
      createdAt: (json['createdAt'] ?? '').toString(),
      updatedAt: (json['updatedAt'] ?? '').toString(),
      allergyAlerts: json['allergyAlerts'] as bool? ?? false,
      reactionToMedication: json['reactionToMedication'] as bool? ?? false,
      caregiver: parseMap(json['caregiver']) != null
          ? CaregiverModel.fromJson(parseMap(json['caregiver'])!)
          : null,
      emergencyContact: parseMap(json['emergencyContact']) != null
          ? EmergencyContactModel.fromJson(
              parseMap(json['emergencyContact'])!,
            )
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
      if (emergencyContact != null) 'emergencyContact': emergencyContact!.toJson(),
    };
  }
}
