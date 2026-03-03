class PatientModel {
  final String userId;
  final List<String> chronicConditions;
  final List<String> allergies;
  final List<String> activeIngredients;
  final List<String> longTermMedication;
  final List<String> medications;
  final bool saveOption;
  final String id;
  final List<String> connectedDoctors;
  final String createdAt;
  final String updatedAt;
  final int version;

  PatientModel({
    required this.userId,
    required this.chronicConditions,
    required this.allergies,
    required this.activeIngredients,
    required this.longTermMedication,
    required this.medications,
    required this.saveOption,
    required this.id,
    required this.connectedDoctors,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      userId: json['userId'] as String,
      chronicConditions: List<String>.from(json['chronicConditions'] as List? ?? []),
      allergies: List<String>.from(json['allergies'] as List? ?? []),
      activeIngredients: List<String>.from(json['activeIngredients'] as List? ?? []),
      longTermMedication: List<String>.from(json['longTermMedication'] as List? ?? []),
      medications: List<String>.from(json['medications'] as List? ?? []),
      saveOption: json['saveOption'] as bool? ?? false,
      id: json['_id'] as String,
      connectedDoctors: List<String>.from(json['connectedDoctors'] as List? ?? []),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      version: json['__v'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'chronicConditions': chronicConditions,
      'allergies': allergies,
      'activeIngredients': activeIngredients,
      'longTermMedication': longTermMedication,
      'medications': medications,
      'saveOption': saveOption,
      '_id': id,
      'connectedDoctors': connectedDoctors,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
    };
  }
}
