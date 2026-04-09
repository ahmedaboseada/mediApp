import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_cubit.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_state.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CaregiverFormScreen extends StatefulWidget {
  const CaregiverFormScreen({super.key});

  @override
  State<CaregiverFormScreen> createState() => _CaregiverFormScreenState();
}

class _CaregiverFormScreenState extends State<CaregiverFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRelationship = 'parent';

  final List<DropdownItem<String>> _relationshipOptions = [
    DropdownItem(label: 'Parent', value: 'parent'),
    DropdownItem(label: 'Child', value: 'child'),
    DropdownItem(label: 'Spouse', value: 'spouse'),
    DropdownItem(label: 'Sibling', value: 'sibling'),
    DropdownItem(label: 'Other', value: 'other'),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryText),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<QuestionnaireCubit, QuestionnaireState>(
        listener: (context, state) {
          if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          } else if (!state.isLoading && state.error == null) {
            // Check if we just completed a caregiver request (not navigating from back button)
            // Only navigate if the state changed from loading to not loading
            if (state.error == null) {
              context.go(
                '${AppRouter.onboardingFlow}${AppRouter.invitationSendScreen}',
              );
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
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
                      style: AppStyles.black24700,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSizes.h8),
                    // Subtitle
                    Text(
                      AppStrings.createProfileForSomeoneYouCareFor,
                      style: AppStyles.tertiary14500,
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
                        if (selectedList.isNotEmpty) {
                          setState(() {
                            _selectedRelationship = selectedList.first;
                          });
                          print(
                            'Selected relationship: $_selectedRelationship',
                          );
                        }
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
                      style: AppStyles.tertiary14500,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSizes.h32),
                    // Send Invitation Button
                    PrimaryButton(
                      text: AppStrings.sendInvitation,
                      onPressed: state.isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                log(
                                  'Sending invitation to ${_nameController.text} (${_emailController.text})',
                                );

                                cubit.sendCaregiverRequest(
                                  caregiverEmail: _emailController.text.trim(),
                                  relationship: _selectedRelationship,
                                );
                              }
                            },
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
