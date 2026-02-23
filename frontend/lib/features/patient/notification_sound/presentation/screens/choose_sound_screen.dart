import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/notification_sound/presentation/widgets/sound_selector_card.dart';

class ChooseSoundScreen extends StatelessWidget {
  const ChooseSoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(AppSizes.h16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              AppAssets.ringtone,
              height: AppSizes.h300,
              fit: BoxFit.contain,
            ),
            Text(
              AppStrings.pickYourReminderTone,
              style: AppStyles.black24700.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.h16),
            // Subtitle
            Text(
              AppStrings.forWhatMattersMostChooseASoundYouWontIgnore,
              style: AppStyles.tertiary14500,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.h24),
            const SoundSelectorCard(),
            SizedBox(height: AppSizes.h16),
            InfoNoteWidget(text: AppStrings.youCanAlwaysChangeThisLater),
            SizedBox(height: AppSizes.h24),
            PrimaryButton(
              text: AppStrings.continueText,
              onPressed: () {
               context.push(AppRouter.allowNotificationScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}
