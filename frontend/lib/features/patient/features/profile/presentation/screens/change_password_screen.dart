import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

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
      // TODO: Implement actual password change logic with API
      // For now, just show success message
      
      if (context.mounted) {
        _showChangePasswordDialog(context);
      }
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        clipBehavior: Clip.hardEdge,
        constraints: BoxConstraints(
          maxWidth: double.infinity,
        ),
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
                  Navigator.pop(context);
                },
                text: 'Okay',
              ),
              SizedBox(height: AppSizes.h12),
              
              // Cancel Button
              // SecondryButton(
              //   onPressed: () => Navigator.pop(context),
              //   text: 'Cancel',
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
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
                      validator: (value) =>
                          value.validateConfirmPassword(_newPasswordController.text),
                    ),
                    SizedBox(height: AppSizes.h16),

                    // Forget Password Link
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomTextButton2(
                        label: 'Forget your Password?',
                        route: AppRouter.forgetPasswordScreen,
                        fontSize: AppSizes.sp14,
                      ),
                    ),
                    SizedBox(height: AppSizes.h24),

                    // Change Password Button
                    PrimaryButton(
                      onPressed: () => _changePassword(context),
                      text: 'Change Password',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
