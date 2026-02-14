import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';

class SignUpLink extends StatelessWidget {
  final VoidCallback? onPressed;

  const SignUpLink({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.primaryText,
            fontSize: AppSizes.sp12,
          ),
          children: [
            WidgetSpan(
              child: GestureDetector(
                onTap: onPressed,
                child: Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: AppSizes.sp12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
