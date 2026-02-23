import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  String? _currentPath;

  Future<void> play(String path) async {
    if (_currentPath == path && _player.playing) {
      await stop();
      return;
    }

    _currentPath = path;

    await _player.stop();

    if (path.startsWith('assets/')) {
      await _player.setAsset(path);
    } else {
      await _player.setFilePath(path);
    }

    _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}