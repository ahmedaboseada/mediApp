import 'package:shared_preferences/shared_preferences.dart';
import '../models/sound_model.dart';
import 'local_sound_datasource.dart';

class LocalSoundDataSourceImpl implements LocalSoundDataSource {
  final SharedPreferences prefs;

  LocalSoundDataSourceImpl(this.prefs);

  static const _selectedKey = "selected_sound";

  @override
  Future<List<SoundModel>> getSounds() async {
    return [
      SoundModel(
        id: "pill_shaking",
        name: "Pill Shaking",
        path: "assets/sounds/pill_shaking.mp3",
      ),
      SoundModel(
        id: "bell_sound",
        name: "Bell Sound",
        path: "assets/sounds/bell_sound.mp3",
      ),
      SoundModel(
        id: "my_therapy",
        name: "My Therapy",
        path: "assets/sounds/my_therapy.mp3",
      ),
      SoundModel(
        id: "my_therapy_2",
        name: "My Therapy 2",
        path: "assets/sounds/my_therapy_2.mp3",
      ),
    ];
  }

  @override
  Future<void> saveSelected(String path) async {
    await prefs.setString(_selectedKey, path);
  }

  @override
  Future<String?> getSelected() async {
    return prefs.getString(_selectedKey);
  }
}
