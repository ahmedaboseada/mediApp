import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/notification_sound/domain/entities/sound_entity.dart';
import 'package:medi/features/patient/notification_sound/presentation/controller/sound_cubit/sound_cubit.dart';
import 'package:medi/features/patient/notification_sound/presentation/controller/sound_cubit/sound_state.dart';

class SoundSelectorCard extends StatelessWidget {
  const SoundSelectorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SoundCubit, SoundState>(
      builder: (context, state) {
        String selectedSoundName = 'None';

        if (state is SoundLoaded && state.selected != null) {
          selectedSoundName = state.selected!.name;
        }

        return InkWell(
          onTap: () async {
            final result = await context.push(
              AppRouter.notificationSoundScreen,
              extra: context.read<SoundCubit>(),
            );

            if (result is SoundEntity) {
              context.read<SoundCubit>().selectSound(result);
            }
          },
          child: Container(
            padding: EdgeInsets.all(AppSizes.h16),
            decoration: BoxDecoration(
              color: AppColors.whiteText,
              border: Border.all(color: AppColors.cardBorderColor),
              borderRadius: BorderRadius.circular(AppSizes.r8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sound',
                  style: AppStyles.secondary18500.copyWith(
                    fontSize: AppSizes.sp16,
                  ),
                ),
                Text(
                  selectedSoundName,
                  style: AppStyles.secondary18500.copyWith(
                    fontSize: AppSizes.sp16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
