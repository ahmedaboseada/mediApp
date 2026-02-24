import 'package:medi/features/patient/notification_sound/domain/entities/sound_entity.dart';

abstract class SoundRepository {
  Future<List<SoundEntity>> getSounds();
  Future<void> saveSelectedSound(SoundEntity sound);
  Future<SoundEntity?> getSelectedSound();
}
