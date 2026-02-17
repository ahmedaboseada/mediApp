import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/auth/data/models/user_model.dart';
import 'package:medi/features/auth/presentation/cubit/complete_profile/complete_profile_cubit.dart';
import 'package:medi/features/auth/presentation/cubit/complete_profile/complete_profile_state.dart';
import 'package:medi/features/doctor/constants/constants.dart';
import 'package:medi/features/patient/questionnaire/presentation/widgets/q_text_fileld.dart';

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
                  style: AppStyles.screenTitle,
                  textAlign: TextAlign.center,
                ),
                Text(
                  AppStrings.fillPersonalInformation,
                  style: AppStyles.subtitleText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h32),
                Center(
                  child: CircularAvatar(
                    selectedImagePath: selectedImage,
                    networkImageUrl: userModel?.image,
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
                const GenderField(),
                SizedBox(height: AppSizes.h24),
                const PhoneField(),
                SizedBox(height: AppSizes.h32),
                BlocBuilder<ProfileFormCubit, ProfileFormState>(
                  buildWhen: (p, c) => p.isValid != c.isValid,
                  builder: (context, state) {
                    return PrimaryButton(
                      text: AppStrings.completeProfileButton,
                      onPressed: state.isValid
                          ? () {
                              context.go(AppRouter.allowLocationScreen);
                            }
                          : null,
                    );
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
