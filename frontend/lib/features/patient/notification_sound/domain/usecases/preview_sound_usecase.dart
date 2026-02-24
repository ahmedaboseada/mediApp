import 'package:medi/core/core.dart';

class PreviewSoundUseCase {
  final AudioPlayerService audio;

  PreviewSoundUseCase(this.audio);

  Future<void> call(String path) {
    return audio.play(path);
  }
}
