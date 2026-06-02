import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/widgets/common/app_button.dart';

class PaymentFailureScreen extends StatelessWidget {
  const PaymentFailureScreen({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w24,
            vertical: AppSizes.h16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 110,
                height: 110,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.whiteText,
                  size: 56,
                  weight: 700,
                ),
              ),
              SizedBox(height: AppSizes.h24),
              Text(
                'Payment Failed!',
                style: AppStyles.black24700,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h12),
              Text(
                errorMessage ?? 'An unknown error occurred.',
                style: AppStyles.secondary12400,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              AppButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                    return;
                  }

                  context.go(AppRouter.patientPaymentMethodScreen);
                },
                text: 'Try Again',
              ),
              SizedBox(height: AppSizes.h24),
            ],
          ),
        ),
      ),
    );
  }
}
