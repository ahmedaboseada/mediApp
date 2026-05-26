import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:medi/features/shared/auth/presentation/cubit/complete_profile/complete_profile_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/complete_profile/complete_profile_state.dart';

class CompleteYourProfileScreen extends StatefulWidget {
  const CompleteYourProfileScreen({super.key, this.userModel});
  final UserModel? userModel;

  @override
  State<CompleteYourProfileScreen> createState() =>
      _CompleteYourProfileScreenState();
}

class _CompleteYourProfileScreenState extends State<CompleteYourProfileScreen> {
  String? selectedImage;
  String? selectedPhone;
  String? selectedGender;
  String? selectedDateOfBirth;
  String? selectedCountry = 'Egypt';

  Future<void> _saveUserProfile() async {
    // Save all user data to HiveService
    await HiveService.saveUserProfile(
      firstName: widget.userModel?.firstName,
      lastName: widget.userModel?.lastName,
      email: widget.userModel?.email,
      phone: selectedPhone,
      country: selectedCountry,
      dateOfBirth: selectedDateOfBirth,
      gender: selectedGender,
      profileImage: selectedImage ?? widget.userModel?.profilePicture,
    );
  }

  void _completeProfile() {
    if (selectedPhone == null || selectedPhone!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    if (selectedDateOfBirth == null || selectedDateOfBirth!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your date of birth')),
      );
      return;
    }

    if (selectedGender == null || selectedGender!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your gender')),
      );
      return;
    }

    // Extract year from date of birth
    final yearOfBirth = DateTime.parse(selectedDateOfBirth!).year;

    context.read<CompleteProfileCubit>().completeBasicProfile(
      phone: selectedPhone!,
      yearOfBirth: yearOfBirth,
      gender: selectedGender!,
      profilePicture: selectedImage != null ? File(selectedImage!) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CompleteProfileCubit, CompleteProfileState>(
        listener: (context, state) async {
          if (state is CompleteProfileSuccess) {
            await HiveService.markCompleteProfileAsCompleted();
            await _saveUserProfile();
            if (!mounted) {
              return;
            }
            context.go(AppRouter.patientProfileCompletedScreen);
          } else if (state is CompleteProfileFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          final isLoading = state is CompleteProfileLoading;

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
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
                    PhoneField(
                      onPhoneChanged: (phone) {
                        selectedPhone = phone;
                      },
                    ),
                    SizedBox(height: AppSizes.h24),
                    DatePickerField(
                      dateController: TextEditingController(),
                      onDateSelected: (date) {
                        selectedDateOfBirth = date.toString();
                      },
                    ),
                    SizedBox(height: AppSizes.h24),
                    GenderField(
                      value: selectedGender ?? 'male',
                      onGenderChanged: (gender) {
                        selectedGender = gender;
                      },
                    ),

                    SizedBox(height: AppSizes.h32),
                    PrimaryButton(
                      text: AppStrings.completeProfileButton,
                      onPressed: isLoading ? null : _completeProfile,
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
          );
        },
      ),
    );
  }
}
