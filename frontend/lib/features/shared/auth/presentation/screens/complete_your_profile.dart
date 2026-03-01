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
  State<CompleteYourProfileScreen> createState() => _CompleteYourProfileScreenState();
}

class _CompleteYourProfileScreenState extends State<CompleteYourProfileScreen> {
  String? selectedImage;
  String? selectedPhone;
  String? selectedGender;
  String? selectedDateOfBirth;
  String? selectedCountry = 'Egypt';

  Future<void> _saveUserProfile() async {
    // Save all user data to SharedPreferences
    await PrefHelper.saveUserProfile(
      firstName: widget.userModel?.name?.split(' ').first,
      lastName: widget.userModel?.name?.split(' ').last,
      email: widget.userModel?.email,
      phone: selectedPhone,
      country: selectedCountry,
      dateOfBirth: selectedDateOfBirth,
      gender: selectedGender,
      profileImage: selectedImage ?? widget.userModel?.image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    networkImageUrl: widget.userModel?.image,
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
                  dateController: TextEditingController() ,
                  onDateSelected: (date) {
                    selectedDateOfBirth = date.toString();
                  },
                ),
                SizedBox(height: AppSizes.h24),
                GenderField(
                  value: selectedGender ?? 'Male',
                  onGenderChanged: (gender) {
                    selectedGender = gender;
                  },
                ),
                SizedBox(height: AppSizes.h32),
                PrimaryButton(
                  text: AppStrings.completeProfileButton,
                  onPressed: () async {
                    await _saveUserProfile();
                    if (mounted) {
                      context.go(
                        AppRouter.patientProfileCompletedScreen,
                      );
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
