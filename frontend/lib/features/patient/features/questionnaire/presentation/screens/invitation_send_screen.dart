import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_cubit.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_state.dart';

class InvitationSendScreen extends StatelessWidget {
  const InvitationSendScreen({
    super.key,
    this.fromCaregiverMode = false,
    this.requestId,
  });

  final bool fromCaregiverMode;
  final String? requestId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuestionnaireCubit, QuestionnaireState>(
      listener: (context, state) {
        if (state.error != null && state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.isLoading;

        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(AppSizes.w16),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(AppAssets.completeProfile, height: AppSizes.h370),
                  Text(
                    AppStrings.invitationSent,
                    style: AppStyles.black24700.copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSizes.h16),
                  Text(
                    AppStrings.invitationSentMessage,
                    style: AppStyles.tertiary14500,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: AppStrings.done,
                    onPressed: isLoading
                        ? null
                        : () {
                            if (fromCaregiverMode) {
                              context.go(
                                '${AppRouter.patientCaregiverModeScreen}',
                              );
                            } else {
                              context.go(
                                '/onboardingFlow/allSet',
                              );
                            }
                          },
                  ),
                  SizedBox(height: AppSizes.h16),
                  Row(
                    children: [
                      Expanded(
                        child: SecondryButton(
                          text: 'Add relative',
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.push(
                                    '/onboardingFlow/caregiverForm?fromCaregiverMode=$fromCaregiverMode',
                                  );
                                },
                        ),
                      ),
                      SizedBox(width: AppSizes.w16),
                      Expanded(
                        child: SecondryButton(
                          text: 'Cancel',
                          onPressed: isLoading || requestId == null
                              ? null
                              : () async {
                                  final success = await context
                                      .read<QuestionnaireCubit>()
                                      .cancelCaregiverRequest(
                                        requestId: requestId!,
                                      );

                                  if (!context.mounted || !success) {
                                    return;
                                  }

                                  if (fromCaregiverMode) {
                                    context.pop(
                                      // '/onboardingFlow/caregiverMode',
                                    );
                                  } else {
                                    context.go(
                                      '/onboardingFlow/allSet',
                                    );
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
