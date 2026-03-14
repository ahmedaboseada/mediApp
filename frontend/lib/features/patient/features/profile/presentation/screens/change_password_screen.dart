import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/utils/safe_go_router.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/profile/profile_cubit.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _changePassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().changePassword(
        oldPassword: _currentPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
      );
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        clipBehavior: Clip.hardEdge,
        constraints: const BoxConstraints(maxWidth: double.infinity),
        insetPadding: EdgeInsets.all(AppSizes.w16),
        backgroundColor: AppColors.whiteText,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r40),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Change Password',
                style: AppStyles.black24700,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h16),

              // Message
              Text(
                'Your password has been changed successfully\nYou can now login with your new password',
                style: AppStyles.tertiary14400,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h32),

              // Okay Button
              PrimaryButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'Okay',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              // context.showSafeSnackBar(state.message);
              _showChangePasswordDialog(context);
              _currentPasswordController.clear();
              _newPasswordController.clear();
              _confirmPasswordController.clear();
            } else if (state is ChangePasswordFailure) {
              context.showSafeSnackBar(
                state.errors.isNotEmpty
                    ? '${state.message}: ${state.errors.join(', ')}'
                    : state.message,
              );
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.w16),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.w24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      Text(
                        'Security & Privacy',
                        style: AppStyles.black14500.copyWith(
                          fontSize: AppSizes.sp18,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: AppSizes.h24),

                      // Current Password Field
                      CustomTextField(
                        hintText: 'Enter Current Password',
                        label: 'Current Password',
                        controller: _currentPasswordController,
                        isPassword: true,
                        validator: (value) => value.validatePassword(),
                      ),
                      SizedBox(height: AppSizes.h24),

                      // New Password Field
                      CustomTextField(
                        hintText: 'Enter new password',
                        label: 'New Password',
                        controller: _newPasswordController,
                        isPassword: true,
                        validator: (value) => value.validatePassword(),
                      ),
                      SizedBox(height: AppSizes.h24),

                      // Confirm Password Field
                      CustomTextField(
                        hintText: 'Confirm new password',
                        label: 'Confirm Password',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        validator: (value) => value.validateConfirmPassword(
                          _newPasswordController.text,
                        ),
                      ),
                      SizedBox(height: AppSizes.h16),

                      // Forget Password Link
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            context.push(
                              AppRouter.forgetPasswordScreen,
                              extra: UserRole.patient,
                            );
                          },
                          child: const Text(
                            'Forget your Password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.h24),

                      // Change Password Button with Loading State
                      BlocBuilder<ProfileCubit, ProfileState>(
                        buildWhen: (previous, current) =>
                            current is ChangePasswordLoading ||
                            current is ChangePasswordSuccess ||
                            current is ChangePasswordFailure,
                        builder: (context, state) {
                          final isLoading = state is ChangePasswordLoading;
                          return PrimaryButton(
                            text: 'Change Password',

                            onPressed: () => _changePassword(context),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: AppColors.whiteText,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
