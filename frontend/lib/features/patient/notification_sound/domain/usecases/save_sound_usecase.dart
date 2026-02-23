import 'package:medi/features/patient/notification_sound/data/repo/sound_repo.dart';
import 'package:medi/features/patient/notification_sound/domain/entities/sound_entity.dart';

class SaveSoundUseCase {
  final SoundRepository repo;

  SaveSoundUseCase(this.repo);

  Future<void> call(SoundEntity sound) {
    return repo.saveSelectedSound(sound);
  }
}