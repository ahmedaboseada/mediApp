import 'package:medi/features/patient/notification_sound/data/repo/sound_repo.dart';
import 'package:medi/features/patient/notification_sound/domain/entities/sound_entity.dart';

class GetSoundsUseCase {
  final SoundRepository repo;

  GetSoundsUseCase(this.repo);

  Future<List<SoundEntity>> call() {
    return repo.getSounds();
  }
}