import 'package:hive/hive.dart';

part 'caregiver_model.g.dart';

@HiveType(typeId: 6)
class CaregiverModel {
  @HiveField(0)
  final List<String> giving;
  @HiveField(1)
  final bool caregivingOption;

  CaregiverModel({required this.giving, required this.caregivingOption});

  factory CaregiverModel.fromJson(Map<String, dynamic> json) {
    return CaregiverModel(
      giving: List<String>.from(json['giving'] as List? ?? []),
      caregivingOption: json['caregivingOption'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'giving': giving, 'caregivingOption': caregivingOption};
  }
}
