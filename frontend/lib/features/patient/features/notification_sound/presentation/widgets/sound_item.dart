import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import '../../domain/entities/sound_entity.dart';
import '../controller/sound_cubit/sound_cubit.dart';
import '../controller/sound_cubit/sound_state.dart';

class SoundItem extends StatelessWidget {
  final SoundEntity sound;
  final SoundLoaded state;

  const SoundItem({super.key, required this.sound, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SoundCubit>();

    final isSelected = state.selected?.id == sound.id;

    final isPlaying = state.previewingId == sound.id;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        sound.name,
        style: AppStyles.black14500.copyWith(fontSize: AppSizes.sp18),
      ),

      leading: Icon(isPlaying ? Icons.graphic_eq : Icons.music_note),

      trailing: isSelected
          ? Icon(Icons.check, color: AppColors.primary, size: AppSizes.h24)
          : null,

      onTap: () {
        cubit.preview(sound);
        cubit.save();
        if (cubit.state is SoundLoaded) {
          final selected = (cubit.state as SoundLoaded).selected;

          context.pop(selected);
        }
      },
    );
  }
}
