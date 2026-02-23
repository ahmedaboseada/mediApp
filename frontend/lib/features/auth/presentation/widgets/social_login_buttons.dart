import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/auth/presentation/cubit/google_log_in/google_log_in_cubit.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onApplePressed;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.onApplePressed,
  });

  //make goole login logic in onGooglePressed

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocProvider(
          create: (context) => GoogleLogInCubit(getIt<AuthRepoImpl>()),
          child: Builder(
            builder: (context) {
              return BlocConsumer<GoogleLogInCubit, GoogleLogInState>(
                listener: (context, state) {
                  if (state is GoogleLogInSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Google Sign In Successful'),
                      ),
                    );
                    context.go(AppRouter.homeScreen);
                    // Navigate to home screen or desired screen
                  } else if (state is GoogleLogInFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Google Sign In Failed: ${state.error}'),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return SocialLoginButton(
                    icon: SvgPicture.asset(AppAssets.google, height: AppSizes.h24, width: AppSizes.w24),
                    label: 'Google',
                    onPressed: () =>
                        context.read<GoogleLogInCubit>().logInWithGoogle(),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(width: AppSizes.w12),
        SocialLoginButton(
          icon: SvgPicture.asset(AppAssets.facebook, height: AppSizes.h24, width: AppSizes.w24),
          label: 'Facebook',
          onPressed: onFacebookPressed,
        ),
        SizedBox(width: AppSizes.w12),
        SocialLoginButton(
          icon: SvgPicture.asset(AppAssets.apple, height: AppSizes.h24, width: AppSizes.w24),
          label: 'Apple',
          onPressed: onApplePressed,
        ),
      ],
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.w60,
      height: AppSizes.h60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.borderColor, width: 1),
          shape: CircleBorder(),
          padding: EdgeInsets.all(AppSizes.w12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
          ],
        ),
      ),
    );
  }
}
