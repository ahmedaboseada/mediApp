import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/home/data/repo/sos_repo.dart';
import 'package:medi/features/patient/features/home/presentation/controller/sos/sos_cubit.dart';
import 'package:medi/features/patient/features/home/presentation/screens/alert_sent_screen.dart';

class ConfirmEmergencyAlertScreen extends StatefulWidget {
  final String contactName;
  final String contactMethod;

  const ConfirmEmergencyAlertScreen({
    super.key,
    required this.contactName,
    required this.contactMethod,
  });

  @override
  State<ConfirmEmergencyAlertScreen> createState() =>
      _ConfirmEmergencyAlertScreenState();
}

class _ConfirmEmergencyAlertScreenState
    extends State<ConfirmEmergencyAlertScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SosCubit(getIt<SosRepo>()),
        child: SafeArea(
          child: BlocListener<SosCubit, SosState>(
            listener: (context, state) {
              if (state is SosTriggeredSuccess) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AlertSentScreen(
                      contactName: widget.contactName,
                      contactMethod: widget.contactMethod,
                    ),
                  ),
                );
              } else if (state is SosFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: Padding(
              padding: EdgeInsets.all(AppSizes.h24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      // Title
                      Text(
                        'Confirm Emergency Alert',
                        style: AppStyles.black24700,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSizes.h16),

                      // Description
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "We will send an emergency message with your live location to ",
                              style: AppStyles.secondary12400,
                            ),
                            TextSpan(
                              text: widget.contactName,
                              style: AppStyles.black14600,
                            ),
                            TextSpan(
                              text: " via ",
                              style: AppStyles.secondary12400,
                            ),
                            TextSpan(
                              text: widget.contactMethod.toUpperCase(),
                              style: AppStyles.black14600,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSizes.h40),

                      // Illustration
                      _buildIllustration(),
                    ],
                  ),
                  // Buttons
                  Column(
                    children: [
                      BlocBuilder<SosCubit, SosState>(
                        builder: (context, state) {
                          final isLoading = state is SosLoading;
                          return SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              text: 'Send SOS',
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context.read<SosCubit>().triggerSos();
                                    },
                              //  isLoading: isLoading,
                              backgroundColor: AppColors.error,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: AppSizes.h12),
                      SizedBox(
                        width: double.infinity,
                        child: SecondryButton(
                          text: 'Cancel',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    // Simple illustration with animated elements
    return SizedBox(
      height: AppSizes.h200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: AppSizes.w80, color: AppColors.error),
            SizedBox(height: AppSizes.h16),
            Text(
              'Emergency alert will be sent',
              style: AppStyles.black14600,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
