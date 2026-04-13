import 'package:hive/hive.dart';

part 'clinic_location_model.g.dart';

@HiveType(typeId: 5)
class ClinicLocationModel {
  @HiveField(0)
  final double lat;
  @HiveField(1)
  final double lng;
  @HiveField(2)
  final String label;

  ClinicLocationModel({
    required this.lat,
    required this.lng,
    required this.label,
  });

  factory ClinicLocationModel.fromJson(Map<String, dynamic> json) {
    return ClinicLocationModel(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      label: (json['label'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng, 'label': label};
  }
}
