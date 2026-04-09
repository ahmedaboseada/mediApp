import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/notification_sound/presentation/controller/sound_cubit/sound_cubit.dart';
import 'package:medi/features/patient/features/notification_sound/presentation/controller/sound_cubit/sound_state.dart';
import 'package:medi/features/patient/features/notification_sound/presentation/widgets/sound_list.dart';

class NotificationSoundScreen extends StatelessWidget {
  const NotificationSoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SoundCubit>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (cubit.state is SoundLoaded) {
              final selected = (cubit.state as SoundLoaded).selected;

              context.pop(selected);
            }
          },
        ),
        title: const Text("Notification Sound"),
      ),
      body: BlocBuilder<SoundCubit, SoundState>(
        builder: (context, state) {
          if (state is SoundLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SoundLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.h16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: SoundList(state: state),
                    ),

                    Divider(color: AppColors.cardBorderColor),
                    SizedBox(height: AppSizes.h16),
                    Text(
                      'Custom sound',
                      style: AppStyles.secondary18500.copyWith(
                        fontSize: AppSizes.sp16,
                      ),
                    ),
                    Text(
                      'Select a sound from your device',
                      style: AppStyles.secondary18500.copyWith(
                        fontSize: AppSizes.sp14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: AppSizes.h16),
                    PrimaryButton(
                      backgroundColor: AppColors.background,
                      textColor: AppColors.primary,
                      text: "Add Custom Sound",
                      onPressed: () {},
                    ),
                    SizedBox(height: AppSizes.h16),
                    Divider(thickness: 1, color: AppColors.cardBorderColor),
                    SizedBox(height: AppSizes.h16),
                    Text('No sound', style: AppStyles.black14400),
                    SizedBox(height: AppSizes.h8),

                    Text(
                      'Silent',
                      style: AppStyles.black14500.copyWith(
                        fontSize: AppSizes.sp18,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: AppSizes.h8),
                    Text(
                      'Vibration',
                      style: AppStyles.black14500.copyWith(
                        fontSize: AppSizes.sp18,
                      ),
                    ),
                    SizedBox(height: AppSizes.h16),
                    Divider(color: AppColors.cardBorderColor),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
