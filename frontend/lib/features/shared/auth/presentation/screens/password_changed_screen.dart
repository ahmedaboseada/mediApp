import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key, required this.role});
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SvgPicture.asset('assets/images/Sticker.svg'),
            SizedBox(height: AppSizes.h24),
            Text(
              'Password Changed!',
              style: AppStyles.black24700,
              textAlign: TextAlign.center,
            ),
            Text(
              'Your password has been changed\n successfully.',
              style: AppStyles.tertiary14500.copyWith(fontSize: AppSizes.sp18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.h32),
            PrimaryButton(
              text: 'Back to Sign In',
              onPressed: () {
                if (role == UserRole.doctor) {
                  context.go(AppRouter.doctorLogin);
                } else {
                  context.go(AppRouter.patientLogin);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
