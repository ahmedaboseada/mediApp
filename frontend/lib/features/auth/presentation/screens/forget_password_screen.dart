import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/utils/safe_go_router.dart';
import 'package:medi/features/auth/presentation/cubit/forget_password/forget_password_cubit.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ForgetPasswordSuccess) {
              context.showSafeSnackBar(state.message);
              context.safeGo(
                AppRouter.otpScreen,
                extra: _emailController.text.trim(),
              );
            } else if (state is ForgetPasswordFailure) {
              context.showSafeSnackBar("${state.error},error");
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tablets Image
                    Image.asset(AppAssets.tablets, height: AppSizes.h300),

                    // Forget Password Title
                    Text(
                      AppStrings.forgetPassword,
                      style: AppStyles.screenTitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSizes.h8),

                    // Subtitle
                    Text(
                      AppStrings.restoreAccessMessage,
                      style: AppStyles.subtitleText,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSizes.h32),

                    // Email TextField
                    CustomTextField(
                      autofillHints: const [AutofillHints.email],
                      hintText: AppStrings.emailHint,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value.validateEmail(),
                      label: AppStrings.emailHint,
                    ),
                    SizedBox(height: AppSizes.h32),

                    // Submit Button
                    PrimaryButton(
                      text: AppStrings.submit,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<ForgetPasswordCubit>()
                              .submitForgetPassword(
                                _emailController.text.trim(),
                              );
                        }
                      },
                    ),
                    SizedBox(height: AppSizes.h40),
                    Text(
                      AppStrings.fatherInformation,
                      textAlign: TextAlign.center,
                      style: AppStyles.subtitleText,
                    ),
                    SizedBox(height: AppSizes.h8),
                    Text(
                      AppStrings.contactSupportTeam,
                      textAlign: TextAlign.center,
                      style: AppStyles.bodyText.copyWith(
                        fontSize: AppSizes.sp16,
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
