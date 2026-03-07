import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:medi/features/doctor/constants/constants.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/cubit/doctor_complete_profile_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/cubit/doctor_complete_profile_state.dart';

class DoctorCompleteProfile extends StatefulWidget {
  const DoctorCompleteProfile({super.key, this.userModel});
  final UserModel? userModel;

  @override
  State<DoctorCompleteProfile> createState() => _DoctorCompleteProfileState();
}

class _DoctorCompleteProfileState extends State<DoctorCompleteProfile> {
  final _formKey = GlobalKey<FormState>();
  String? selectedImage;
  String? selectedSpecialization;
  String selectedGender = 'male';
  String selectedPhone = '';
  final TextEditingController _clinicController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  @override
  void dispose() {
    _clinicController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  void _submitStep1() {
    if (selectedSpecialization == null || selectedSpecialization!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select specialization')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<DoctorCompleteProfileCubit>().completeStep1(
      specialization: selectedSpecialization!,
      clinicName: _clinicController.text.trim(),
      medicalLicenseId: _licenseController.text.trim(),
      phone: selectedPhone.trim(),
      gender: selectedGender,
      profilePicture: selectedImage ?? widget.userModel?.profilePicture,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body:
          BlocConsumer<DoctorCompleteProfileCubit, DoctorCompleteProfileState>(
            listener: (context, state) {
              if (state is DoctorCompleteProfileSuccess) {
                context.go(AppRouter.allowLocationScreen);
                return;
              }

              if (state is DoctorCompleteProfileFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              final isLoading = state is DoctorCompleteProfileLoading;

              return SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppStrings.completeYourProfile,
                            style: AppStyles.black24700,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            AppStrings.fillPersonalInformation,
                            style: AppStyles.tertiary14500,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSizes.h32),
                          Center(
                            child: CircularAvatar(
                              selectedImagePath: selectedImage,
                              networkImageUrl: widget.userModel?.profilePicture,
                              onImagePicked: (path) {
                                setState(() {
                                  selectedImage = path;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: AppSizes.h24),
                          QTextField(
                            singleSelect: true,
                            onSelectionChange: (values) {
                              if (values.isEmpty) {
                                return;
                              }
                              selectedSpecialization = values.first;
                            },
                            items: DoctorConstants().spicilizations,
                            label: 'Specialization',
                          ),
                          SizedBox(height: AppSizes.h24),
                          CustomTextField(
                            controller: _clinicController,
                            hintText: AppStrings.clinicHospitalName,
                            label: AppStrings.clinicHospitalName,
                            validator: (value) => value.validateClinicName(),
                          ),
                          SizedBox(height: AppSizes.h24),
                          CustomTextField(
                            controller: _licenseController,
                            hintText: AppStrings.medicalLicenseNumber,
                            label: AppStrings.medicalLicenseNumber,
                            validator: (value) =>
                                value.validateMedicalLicense(),
                          ),
                          SizedBox(height: AppSizes.h24),
                          GenderField(
                            value: selectedGender,
                            onGenderChanged: (gender) {
                              selectedGender = gender;
                            },
                          ),
                          SizedBox(height: AppSizes.h24),
                          PhoneField(
                            onPhoneChanged: (phone) {
                              selectedPhone = phone;
                            },
                          ),
                          SizedBox(height: AppSizes.h32),
                          PrimaryButton(
                            text: AppStrings.completeProfileButton,
                            onPressed: isLoading ? null : _submitStep1,
                            child: isLoading
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
                ),
              );
            },
          ),
    );
  }
}
