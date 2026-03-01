import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class ChangeEmailScreen extends StatelessWidget {
  ChangeEmailScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();

  Future<void> _changeEmail(BuildContext context, String currentEmail) async {
    if (_formKey.currentState!.validate()) {
      // Save new email
      await PrefHelper.saveUserProfile(email: _newEmailController.text);
      
      if (context.mounted) {
        _showChangeEmailDialog(context);
      }
    }
  }

  void _showChangeEmailDialog(BuildContext context) {
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
                'Change Email',
                style: AppStyles.black24700,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h16),
              
              // Message
              Text(
                "We've sent a confirmation link to your new email\nPlease confirm to complete the change",
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
              SecondryButton(
                onPressed: () => Navigator.pop(context),
                text: 'Cancel',
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
      appBar: CustomAppBar(),
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: PrefHelper.getEmail(),
          builder: (context, snapshot) {
            final currentEmail = snapshot.data ?? 'Ahmed14@email.com';
            
            return SingleChildScrollView(
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
                        
                        // Current Email Field (Read-only)
                        CustomTextField(
                          hintText: 'Current email',
                          label: 'Email',
                          controller: TextEditingController(text: currentEmail),
                          readOnly: true,
                        ),
                        SizedBox(height: AppSizes.h24),
                        
                        // New Email Field
                        CustomTextField(
                          hintText: 'Enter new email',
                          label: 'New Email',
                          controller: _newEmailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value.validateEmail(),
                        ),
                        SizedBox(height: AppSizes.h24),
                        
                        // Confirm Email Field
                        CustomTextField(
                          hintText: 'Confirm new email',
                          label: 'Confirm Email',
                          controller: _confirmEmailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value.validateConfirmEmail(_newEmailController.text),
                        ),
                        SizedBox(height: AppSizes.h24),
                        
                        // Change Email Button
                        PrimaryButton(
                          onPressed: () => _changeEmail(context, currentEmail),
                          text: 'Change Email',
                        ),
                      ],
                    ),
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