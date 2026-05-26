import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/utils/safe_go_router.dart';
import 'package:medi/features/shared/auth/presentation/cubit/signin/sigin_cubit.dart';
import 'package:medi/features/shared/auth/presentation/widgets/divider_with_text.dart';
import 'package:medi/features/shared/auth/presentation/widgets/forgot_password_button.dart';
import 'package:medi/features/shared/auth/presentation/widgets/sign_up_link.dart';
import 'package:medi/features/shared/auth/presentation/widgets/social_login_buttons.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.role});
  final UserRole role;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _hasAuthError = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearAuthError() {
    if (_hasAuthError) {
      setState(() {
        _hasAuthError = false;
      });
      // Re-validate to remove the error borders
      _formKey.currentState?.validate();
    }
  }

  void _handleSignIn() {
    //context.safeGo(AppRouter.patientMainView);
    if (_formKey.currentState!.validate()) {
      context.read<SiginCubit>().signin(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        widget.role,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: BlocConsumer<SiginCubit, SiginState>(
          listener: (context, state) {
            if (state is SiginSuccess) {
              //context.showSafeSnackBar(AppStrings.signInSuccessful);

              context.safeGo(
                widget.role == UserRole.patient
                    ? '/home'
                    : AppRouter.mainLayout,
              );
            } else if (state is Signin2FARequired) {
              // Navigate to OTP screen for 2FA verification
              context.push(
                AppRouter.otpScreen,
                extra: {
                  'email': state.email,
                  'role': state.role,
                  'is2FA': true,
                },
              );
            } else if (state is SiginFailure) {
              if (state.error == 'Invalid credentials') {
                setState(() {
                  _hasAuthError = true;
                });
                // Trigger validation to show error borders
                _formKey.currentState?.validate();
              } else {
                context.showSafeSnackBar(state.error);
              }
            }
          },
          builder: (context, state) {
            final bool isLoading = state is SiginLoading;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w24,
                  vertical: AppSizes.h32,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header
                      Text(widget.role.title, style: AppStyles.black24700),
                      Text(AppStrings.signIn, style: AppStyles.black24700),
                      SizedBox(height: AppSizes.h8),
                      Text(
                        AppStrings.welcomeBack,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: AppSizes.sp14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.tertiaryText,
                        ),
                      ),
                      SizedBox(height: AppSizes.h64),

                      // Email Field
                      CustomTextField(
                        autofillHints: const [AutofillHints.email],
                        hintText: AppStrings.emailHint,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) => _clearAuthError(),
                        validator: (value) {
                          final emailError = value?.validateEmail();
                          if (emailError != null) return emailError;
                          if (_hasAuthError) {
                            return 'Email or password may be wrong';
                          }
                          return null;
                        },
                        label: AppStrings.emailHint,
                      ),
                      SizedBox(height: AppSizes.h16),

                      // Password Field
                      CustomTextField(
                        autofillHints: const [AutofillHints.password],
                        hintText: AppStrings.passwordHint,
                        controller: _passwordController,
                        isPassword: true,
                        onChanged: (_) => _clearAuthError(),
                        validator: (value) {
                          if (_hasAuthError) {
                            return 'Email or password may be wrong';
                          }
                          return null;
                        },
                        label: AppStrings.passwordHint,
                      ),
                      SizedBox(height: AppSizes.h16),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomTextButton(
                          text: AppStrings.forgotPassword,
                          onPressed: () {
                            context.push(
                              AppRouter.forgetPasswordScreen,
                              extra: widget.role,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: AppSizes.h32),

                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.h48,
                        child: PrimaryButton(
                          onPressed: isLoading ? null : _handleSignIn,

                          child: isLoading
                              ? SizedBox(
                                  width: AppSizes.w24,
                                  height: AppSizes.w24,
                                  child: const CircularProgressIndicator(
                                    color: AppColors.whiteText,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  AppStrings.signIn,
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: AppColors.whiteText,
                                        fontSize: AppSizes.sp16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                        ),
                      ),
                      SizedBox(height: AppSizes.h24),

                      // Divider with text
                      const DividerWithText(text: AppStrings.orSignInWith),
                      SizedBox(height: AppSizes.h24),

                      // Social Login Buttons
                      SocialLoginButtons(
                        userRole: widget.role,
                        onGooglePressed: () {},
                        onFacebookPressed: () {},
                        onApplePressed: () {},
                      ),
                      SizedBox(height: AppSizes.h32),

                      // Sign Up Link
                      SignUpLink(
                        onPressed: () {
                          if (widget.role == UserRole.doctor) {
                            context.go(AppRouter.doctorSignUpScreen);
                          } else {
                            context.go(AppRouter.signUpScreen);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
