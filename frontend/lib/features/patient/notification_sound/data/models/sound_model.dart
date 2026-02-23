import 'package:medi/features/patient/notification_sound/domain/entities/sound_entity.dart';

class SoundModel extends SoundEntity {
  SoundModel({
    required super.id,
    required super.name,
    required super.path,
    super.isCustom,
  });
factory SoundModel.custom(String path) {
    return SoundModel(
      id: path,
      name: path.split('/').last,
      path: path,
      isCustom: true,
    );
  }
  factory SoundModel.fromJson(Map json) {
    return SoundModel(
      id: json['id'],
      name: json['name'],
      path: json['path'],
      isCustom: json['isCustom'] ?? false,
    );
  }
}