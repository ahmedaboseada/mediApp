import 'package:medi/features/patient/notification_sound/data/datasources/local_sound_datasource.dart';
import 'package:medi/features/patient/notification_sound/data/repo/sound_repo.dart';
import 'package:medi/features/patient/notification_sound/domain/entities/sound_entity.dart';

class SoundRepositoryImpl implements SoundRepository {
  final LocalSoundDataSource local;

  SoundRepositoryImpl(this.local);

  @override
  Future<List<SoundEntity>> getSounds()
      => local.getSounds();

  @override
  Future<void> saveSelectedSound(SoundEntity sound)
      => local.saveSelected(sound.path);

  @override
  Future<SoundEntity?> getSelectedSound() async {
    final path = await local.getSelected();
    if (path == null) return null;

    return SoundEntity(
      id: path,
      name: path.split('/').last,
      path: path,
    );
  }
}