import 'package:medi/features/patient/notification_sound/data/models/sound_model.dart';

abstract class LocalSoundDataSource {
  Future<List<SoundModel>> getSounds();
  Future<void> saveSelected(String path);
  Future<String?> getSelected();
}