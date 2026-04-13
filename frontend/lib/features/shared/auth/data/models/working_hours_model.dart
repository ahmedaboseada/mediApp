import 'package:hive/hive.dart';

part 'working_hours_model.g.dart';

@HiveType(typeId: 4)
class WorkingHoursModel {
  @HiveField(0)
  final String startHour;
  @HiveField(1)
  final String endHour;

  WorkingHoursModel({required this.startHour, required this.endHour});

  factory WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    return WorkingHoursModel(
      startHour: (json['startHour'] ?? '').toString(),
      endHour: (json['endHour'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'startHour': startHour, 'endHour': endHour};
  }
}
