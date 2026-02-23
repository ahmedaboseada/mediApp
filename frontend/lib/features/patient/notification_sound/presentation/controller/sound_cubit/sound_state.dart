import 'package:medi/features/patient/notification_sound/domain/entities/sound_entity.dart';

abstract class SoundState {
  const SoundState();
}

class SoundInitial extends SoundState {
  const SoundInitial();
}

class SoundLoading extends SoundState {
  const SoundLoading();
}

class SoundLoaded extends SoundState {
  final List<SoundEntity> sounds;
  final SoundEntity? selected;
  final String? previewingId;

  const SoundLoaded({
    required this.sounds,
    this.selected,
    this.previewingId,
  });

  SoundLoaded copyWith({
    List<SoundEntity>? sounds,
    SoundEntity? selected,
    String? previewingId,
  }) {
    return SoundLoaded(
      sounds: sounds ?? this.sounds,
      selected: selected ?? this.selected,
      previewingId: previewingId ?? this.previewingId,
    );
  }
}

class SoundError extends SoundState {
  final String message;

  SoundError(this.message);
}