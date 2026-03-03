import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/shared/auth/data/models/user_model.dart';
import 'package:medi/features/doctor/constants/constants.dart';

class DoctorCompleteProfile extends StatelessWidget {
  DoctorCompleteProfile({super.key, this.userModel});
  final UserModel? userModel;
  String? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
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
                    networkImageUrl: userModel?.profilePicture,
                  ),
                ),
                QTextField(
                  onSelectionChange: (value) {
                    print(value);
                  },
                  items: DoctorConstants().spicilizations,
                  label: "Specialization",
                ),
                SizedBox(height: AppSizes.h24),
                CustomTextField(
                  hintText: AppStrings.clinicHospitalName,
                  label: AppStrings.clinicHospitalName,
                ),
                SizedBox(height: AppSizes.h24),
                CustomTextField(
                  hintText: AppStrings.medicalLicenseNumber,
                  label: AppStrings.medicalLicenseNumber,
                ),
                SizedBox(height: AppSizes.h24),
                const GenderField(
                  value: 'Male',
                ),
                SizedBox(height: AppSizes.h24),
                const PhoneField(),
                SizedBox(height: AppSizes.h32),
              PrimaryButton(
                      text: AppStrings.completeProfileButton,
                      onPressed: () {
                        context.go(AppRouter.allowLocationScreen);
                      },

                      //  state.isValid
                      //     ? () {
                      //         context.go(AppRouter.allowLocationScreen);
                      //       }
                      //     : null,
                    )
                  
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
