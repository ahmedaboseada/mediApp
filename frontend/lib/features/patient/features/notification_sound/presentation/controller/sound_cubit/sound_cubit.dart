import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/features/patient/features/notification_sound/data/datasources/local_sound_datasource.dart';
import 'package:medi/features/patient/features/notification_sound/domain/entities/sound_entity.dart';
import 'package:medi/features/patient/features/notification_sound/domain/usecases/get_sounds_usecase.dart';
import 'package:medi/features/patient/features/notification_sound/domain/usecases/preview_sound_usecase.dart';
import 'package:medi/features/patient/features/notification_sound/domain/usecases/save_sound_usecase.dart';

import 'sound_state.dart';

class SoundCubit extends Cubit<SoundState> {
  final PreviewSoundUseCase previewSound;
  final GetSoundsUseCase getSounds;
  final SaveSoundUseCase saveSound;

  SoundCubit(
    LocalSoundDataSource localSoundDataSource, {
    required this.previewSound,
    required this.getSounds,
    required this.saveSound,
  }) : super(SoundInitial());

  /// LOAD
  Future<void> loadSounds() async {
    emit(SoundLoading());

    try {
      final sounds = await getSounds();

      emit(SoundLoaded(sounds: sounds));
    } catch (e) {
      emit(SoundError(e.toString()));
    }
  }

  /// SELECT
  void selectSound(SoundEntity sound) {
    final current = state;

    if (current is! SoundLoaded) return;

    emit(current.copyWith(selected: sound));
  }

  /// PREVIEW
  Future<void> preview(SoundEntity sound) async {
    final current = state;

    if (current is! SoundLoaded) return;

    await previewSound(sound.path);

    emit(current.copyWith(previewingId: sound.id, selected: sound));
  }

  /// SAVE
  Future<void> save() async {
    final current = state;

    if (current is! SoundLoaded) return;
    if (current.selected == null) return;

    await saveSound(current.selected!);
  }

  /// UPDATE LIST (custom sound)
  void addCustomSound(SoundEntity sound) {
    final current = state;

    if (current is! SoundLoaded) return;

    emit(current.copyWith(sounds: [...current.sounds, sound], selected: sound));
  }
}
