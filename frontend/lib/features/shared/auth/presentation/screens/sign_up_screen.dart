import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/utils/safe_go_router.dart';
import 'package:medi/features/shared/auth/presentation/cubit/register/register_cubit.dart';
import 'package:medi/features/shared/auth/presentation/widgets/divider_with_text.dart';
import 'package:medi/features/shared/auth/presentation/widgets/social_login_buttons.dart';
import 'package:medi/features/shared/auth/presentation/widgets/terms_conditions_checkbox.dart';

class SignUpScreen extends StatelessWidget {
  final UserRole role;
  SignUpScreen({super.key, required this.role});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final ValueNotifier<bool> _agreeToTerms = ValueNotifier(false);

  void _handleSignUp(BuildContext context) async {
    // Save initial user data (name and email) to HiveService
    await HiveService.saveUserProfile(
      firstName: _nameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
    );

    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms.value) {
      context.showSafeSnackBar(AppStrings.agreeToTermsMessage);
      return;
    }

    // Get FCM token for push notifications
    String? fcmToken;
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
    }

    context.read<RegisterCubit>().register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
      firstName: _nameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      type: role,
      fcmToken: fcmToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) async {
            if (state is RegisterSuccess) {
              await HiveService.markCompleteProfileAsRequired();
              context.showSafeSnackBar(state.message);
              context.safeGo(
                role == UserRole.patient
                    ? AppRouter.completeProfile
                    : AppRouter.doctorCompleteProfile,
                extra: _emailController.text.trim(),
              );
            } else if (state is RegisterFailure) {
              context.showSafeSnackBar(
                state.errors.isNotEmpty
                    ? '${state.message}: ${state.errors.join(', ')}'
                    : state.message,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is RegisterLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w16,
                vertical: AppSizes.h16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: AppSizes.h12),
                    Text(
                      AppStrings.createAccount,
                      style: AppStyles.black24700,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSizes.h8),
                    Text(
                      role.title,
                      textAlign: TextAlign.center,
                      style: AppStyles.tertiary14500.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    Text(
                      AppStrings.signUpMessage,
                      textAlign: TextAlign.center,
                      style: AppStyles.black14400.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: AppSizes.h32),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            autofillHints: const [AutofillHints.name],
                            hintText: AppStrings.firstNameHint,
                            controller: _nameController,
                            validator: (value) => value.validateFirstName(),
                            label: AppStrings.firstNameHint,
                          ),
                        ),
                        SizedBox(width: AppSizes.w16),
                        Expanded(
                          child: CustomTextField(
                            autofillHints: const [AutofillHints.name],
                            hintText: AppStrings.lastNameHint,
                            controller: _lastNameController,
                            validator: (value) => value.validateLastName(),
                            label: AppStrings.lastNameHint,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h20),
                    CustomTextField(
                      autofillHints: const [AutofillHints.email],
                      hintText: AppStrings.emailHint,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value.validateEmail(),
                      label: AppStrings.emailHint,
                    ),
                    SizedBox(height: AppSizes.h20),
                    CustomTextField(
                      autofillHints: const [AutofillHints.password],
                      hintText: AppStrings.passwordHint,
                      controller: _passwordController,
                      isPassword: true,
                      validator: (value) => value.validatePassword(),
                      label: AppStrings.passwordHint,
                    ),

                    SizedBox(height: AppSizes.h20),

                    CustomTextField(
                      autofillHints: const [AutofillHints.password],
                      hintText: AppStrings.confirmPasswordHint,
                      controller: _confirmPasswordController,
                      isPassword: true,
                      validator: (value) => value.validateConfirmPassword(
                        _passwordController.text,
                      ),
                      label: AppStrings.confirmPasswordHint,
                    ),

                    ValueListenableBuilder<bool>(
                      valueListenable: _agreeToTerms,
                      builder: (context, value, _) {
                        return TermsConditionsCheckbox(
                          value: value,
                          onChanged: (val) => _agreeToTerms.value = val,
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.h24),

                    PrimaryButton(
                      text: isLoading ? '' : AppStrings.signUp,
                      onPressed: () => _handleSignUp(context),
                      child: isLoading
                          ? SizedBox(
                              width: AppSizes.w24,
                              height: AppSizes.h24,
                              child: CircularProgressIndicator(
                                color: AppColors.whiteText,
                                strokeWidth: AppSizes.p2,
                              ),
                            )
                          : null,
                    ),
                    SizedBox(height: AppSizes.h20),

                    DividerWithText(text: AppStrings.orSignInWith),
                    SizedBox(height: AppSizes.h20),

                    SocialLoginButtons(
                      userRole: role,
                      onGooglePressed: () {},
                      onFacebookPressed: () {},
                      onApplePressed: () {},
                    ),
                    SizedBox(height: AppSizes.h20),
                    TextButton(
                      onPressed: () {},
                      child: Text('resend confirmation email'),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.alreadyHaveAccount,
                          style: AppStyles.black14400.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(
                            role == UserRole.patient
                                ? AppRouter.patientLogin
                                : AppRouter.doctorLogin,
                          ),
                          child: Text(
                            AppStrings.signIn,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: AppSizes.sp14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
