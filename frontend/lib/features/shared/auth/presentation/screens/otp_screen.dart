import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/utils/safe_go_router.dart';
import 'package:medi/features/shared/auth/presentation/cubit/otp/otp_cubit.dart';
import 'package:medi/features/shared/auth/presentation/widgets/forgot_password_button.dart';
import '../widgets/otp_field.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({
    super.key,
    required this.email,
    required this.role,
    this.is2FA = false,
  });

  final String email;
  final UserRole role;
  final bool is2FA;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is OtpSuccess) {
              context.showSafeSnackBar(state.message);
              final token = context.read<OtpCubit>().resetToken;
              context.safeGo(
                AppRouter.setPasswordScreen,
                extra: {'resetToken': token, 'role': role},
              );
            }

            if (state is Otp2FASuccess) {
              context.showSafeSnackBar(state.message);
              // Navigate to appropriate main view based on role
              context.safeGo(
                state.role == UserRole.patient
                    ? '/'
                    : AppRouter.mainLayout,
              );
            }

            if (state is OtpFailure) {
              context.showSafeSnackBar(state.error);
            }

            if (state is ResendOtpSuccess) {
              context.showSafeSnackBar(state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is OtpLoading;
            final isResending = state is ResendOtpLoading;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w24,
                  vertical: AppSizes.h32,
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => context.safePop(),
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                    ),

                    SizedBox(height: AppSizes.h24),

                    Text(
                      is2FA
                          ? 'Two-Factor Authentication'
                          : AppStrings.verifyOtp,
                      style: AppStyles.black24700,
                    ),
                    SizedBox(height: AppSizes.h8),
                    Text(
                      is2FA
                          ? 'Enter the OTP sent to your email for verification'
                          : '${AppStrings.enterOtpSent}\n $email',
                      style: AppStyles.tertiary14500,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: AppSizes.h40),

                    /// OTP Field
                    PinCodeField(
                      onChanged: (value) {
                        context.read<OtpCubit>().onOtpChanged(value);
                      },
                    ),

                    SizedBox(height: AppSizes.h32),

                    /// Resend
                    Text(AppStrings.didntReceiveOtp),
                    CustomTextButton(
                      text: isResending ? 'Resending...' : AppStrings.resendOtp,
                      onPressed: isResending
                          ? null
                          : () {
                              context.read<OtpCubit>().resendOtp(email);
                            },
                    ),

                    SizedBox(height: AppSizes.h32),

                    /// Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.h48,
                      child: PrimaryButton(
                        text: AppStrings.verify,
                        onPressed: isLoading
                            ? null
                            : () {
                                if (is2FA) {
                                  context.read<OtpCubit>().verify2FAOTP(role);
                                } else {
                                  context.read<OtpCubit>().verifyOtp(email);
                                }
                              },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: AppColors.whiteText,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
