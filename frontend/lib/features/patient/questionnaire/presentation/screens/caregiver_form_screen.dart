import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/questionnaire/presentation/widgets/q_text_fileld.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CaregiverFormScreen extends StatelessWidget {
  CaregiverFormScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  final List<DropdownItem<String>> _relationshipOptions = [
    DropdownItem(label: 'Parent', value: 'Parent'),
    DropdownItem(label: 'Child', value: 'Child'),
    DropdownItem(label: 'Spouse', value: 'Spouse'),
    DropdownItem(label: 'Sibling', value: 'Sibling'),
    DropdownItem(label: 'Other', value: 'Other'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w16,
            vertical: AppSizes.h24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  AppStrings.addSomeoneYouCareFor,
                  style: AppStyles.screenTitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h8),
                // Subtitle
                Text(
                  AppStrings.createProfileForSomeoneYouCareFor,
                  style: AppStyles.subtitleText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h40),
                // Name TextField
                CustomTextField(
                  hintText: 'Name',
                  controller: _nameController,
                  validator: (value) => value.validateFirstName(),
                  label: 'Name',
                ),
                SizedBox(height: AppSizes.h24),
                // Relationship QTextField
                QTextField(
                  singleSelect: true,
                  onSelectionChange: (selectedList) {
                    // Handle relationship selection
                    print(selectedList);
                  },
                  items: _relationshipOptions,
                  label: 'Relationship',
                ),
                SizedBox(height: AppSizes.h24),
                // Email TextField
                CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value.validateEmail(),
                  label: 'Email',
                ),
                SizedBox(height: AppSizes.h16),
                // Invitation message
                Text(
                  AppStrings.invitationToJoinCareCircle,
                  style: AppStyles.subtitleText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h32),
                // Send Invitation Button
                PrimaryButton(
                  text: AppStrings.sendInvitation,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle send invitation
                      print('Name: ${_nameController.text}');
                      print('Email: ${_emailController.text}');
                      context.go(AppRouter.invitationSendScreen);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
