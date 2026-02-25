import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/utils/safe_go_router.dart';
import 'package:medi/features/shared/auth/presentation/cubit/reset_password/reset_password_cubit.dart';

class SetPasswordScreen extends StatelessWidget {
  SetPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final args = state.extra;

    if (args == null || args is! Map<String, String>) {
      return const Scaffold(
        body: Center(child: Text('Invalid navigation data')),
      );
    }

    final email = args['email'];
    final otp = args['otp'];

    if (email == null || otp == null) {
      return const Scaffold(body: Center(child: Text('Missing reset data')));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.safePop(),
        ),
      ),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            context.showSafeSnackBar(state.message);
            context.safeGo(AppRouter.passwordChangedScreen);
          } else if (state is ResetPasswordFailure) {
            context.showSafeSnackBar(state.error);
          }
        },
        builder: (context, state) {
          final isLoading = state is ResetPasswordLoading;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w20,
              vertical: AppSizes.h16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SvgPicture.asset(
                    AppAssets.updatePassword,
                    height: AppSizes.h200,
                  ),
                  Text(AppStrings.updatePassword, style: AppStyles.black24700),
                  SizedBox(height: AppSizes.h12),
                  Text(
                    AppStrings.newPasswordMessage,
                    style: AppStyles.tertiary14500,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  CustomTextField(
                    autofillHints: const [AutofillHints.newPassword],
                    controller: _passwordController,
                    hintText: AppStrings.passwordHint,
                    isPassword: true,
                    validator: (v) => v.validatePassword(),
                    label: AppStrings.passwordHint,
                  ),
                  SizedBox(height: AppSizes.h16),

                  CustomTextField(
                    autofillHints: const [AutofillHints.newPassword],
                    controller: _confirmPasswordController,
                    hintText: AppStrings.confirmPasswordHint,
                    isPassword: true,
                    validator: (v) =>
                        v.validateConfirmPassword(_passwordController.text),
                    label: AppStrings.confirmPasswordHint,
                  ),

                  SizedBox(height: AppSizes.h34),

                  PrimaryButton(
                    text: AppStrings.createNewPassword,
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ResetPasswordCubit>().resetPassword(
                                email: email,
                                otp: otp,
                                newPassword: _passwordController.text.trim(),
                              );
                            }
                          },
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.whiteText,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
