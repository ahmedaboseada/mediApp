import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/widgets/circular_avatar.dart';
import 'package:medi/features/auth/data/models/user_model.dart';
import 'package:medi/features/auth/presentation/widgets/gender_field.dart';
import 'package:medi/features/auth/presentation/widgets/phone_field.dart';

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
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
      ),
      body:SingleChildScrollView(
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
              SizedBox(height: AppSizes.h24),
              const PhoneField(),
             
              SizedBox(height: AppSizes.h24),
              const GenderField(),
              SizedBox(height: AppSizes.h24),
              PrimaryButton(
                text: AppStrings.completeProfileButton,
                onPressed: () {
                  context.go(AppRouter.profileCompletedScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}