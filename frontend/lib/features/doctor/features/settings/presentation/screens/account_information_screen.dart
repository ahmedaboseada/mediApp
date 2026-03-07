import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/constants/constants.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_state.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  State<AccountInformationScreen> createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _medicalLicenseController =
      TextEditingController();

  String? _selectedPhone;
  String? _selectedGender;
  String? _selectedSpecialization;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _clinicNameController.dispose();
    _medicalLicenseController.dispose();
    super.dispose();
  }

  void _populateFields(UserProfileLoaded state) {
    final user = state.profile.user;
    final doctor = state.profile.doctor;

    _nameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _emailController.text = user.email;
    _phoneController.text = user.phone ?? '';

    setState(() {
      _selectedGender = user.gender;
      if (doctor != null) {
        _selectedSpecialization = doctor.specialization;
        _clinicNameController.text = doctor.clinicName;
        _medicalLicenseController.text = doctor.medicalLicenseId;
      }
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<UserProfileCubit>().updateProfile(
        firstName: _nameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _selectedPhone,
        gender: _selectedGender,
        specialization: _selectedSpecialization,
        clinicName: _clinicNameController.text.trim(),
        medicalLicenseId: _medicalLicenseController.text.trim(),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(getIt<AuthRepoImpl>())..getMe(),
      child: Scaffold(
        appBar: CustomAppBar(),
        body: BlocListener<UserProfileCubit, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileLoaded) {
              _populateFields(state);
            } else if (state is UserProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }else if (state is UserProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              context.pop();
            }
          },
          child: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state is UserProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is UserProfileLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_nameController.text.isEmpty) {
                    _populateFields(state);
                  }
                });
              }

              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.w16),
                    child: Card(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.w16,
                          vertical: AppSizes.h16,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Account Information',
                                style: AppStyles.black14500.copyWith(
                                  fontSize: AppSizes.sp18,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: AppSizes.h24),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      autofillHints: const [AutofillHints.name],
                                      hintText: AppStrings.firstNameHint,
                                      controller: _nameController,
                                      validator: (value) =>
                                          value.validateFirstName(),
                                      label: AppStrings.firstNameHint,
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.w16),
                                  Expanded(
                                    child: CustomTextField(
                                      autofillHints: const [AutofillHints.name],
                                      hintText: AppStrings.lastNameHint,
                                      controller: _lastNameController,
                                      validator: (value) =>
                                          value.validateLastName(),
                                      label: AppStrings.lastNameHint,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSizes.h24),
                              CustomTextField(
                                autofillHints: const [AutofillHints.email],
                                hintText: AppStrings.emailHint,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) => value.validateEmail(),
                                label: AppStrings.emailHint,
                              ),
                              SizedBox(height: AppSizes.h24),
                              PhoneField(
                                phonecontroller: _phoneController,
                                onPhoneChanged: (phone) {
                                  _selectedPhone = phone;
                                },
                              ),
                              SizedBox(height: AppSizes.h24),
                              QTextField(
                                onSelectionChange: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      _selectedSpecialization = value.first;
                                    });
                                  }
                                },
                                items: DoctorConstants().spicilizations,
                                label: "Specialization",
                                singleSelect: true,
                              ),
                              SizedBox(height: AppSizes.h24),
                              CustomTextField(
                                hintText: AppStrings.clinicHospitalName,
                                label: AppStrings.clinicHospitalName,
                                controller: _clinicNameController,
                              ),
                              SizedBox(height: AppSizes.h24),
                              CustomTextField(
                                hintText: AppStrings.medicalLicenseNumber,
                                label: AppStrings.medicalLicenseNumber,
                                controller: _medicalLicenseController,
                              ),
                              SizedBox(height: AppSizes.h24),
                              GenderField(
                                value: _selectedGender ?? 'male',
                                onGenderChanged: (gender) {
                                  setState(() {
                                    _selectedGender = gender;
                                  });
                                },
                              ),
                              SizedBox(height: AppSizes.h24),
                              PrimaryButton(
                                onPressed: _saveProfile,
                                text: 'Save',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
