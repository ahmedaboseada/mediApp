// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:medi/core/core.dart';

// class WelcomScreen extends StatelessWidget {
//   const WelcomScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Image.asset('assets/images/welcom.png'),
//             SizedBox(height: AppSizes.h40),
//             PrimaryButton(
//               text: AppStrings.login,
//               onPressed: () {
//                 //navigate to login screen
//                 context.go(AppRouter.signInScreen);
//               },
//             ),
//             SizedBox(height: AppSizes.h16),
//             PrimaryButton(
//               text: AppStrings.signUp,
//               onPressed: () {
//                 //navigate to sign up screen
//                 context.go(AppRouter.signUpScreen);
//               },
//               backgroundColor: AppColors.secondary,
//               textColor: AppColors.primary,
//             ),
//             SizedBox(height: AppSizes.h12),
//             Text(
//               AppStrings.welcome,
//               textAlign: TextAlign.center,
//               style: AppStyles.supportingText,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
