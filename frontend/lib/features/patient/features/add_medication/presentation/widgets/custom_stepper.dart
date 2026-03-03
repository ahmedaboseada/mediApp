import 'package:flutter/material.dart';
import 'package:medi/core/constants/app_sizes.dart';

class CustomStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String title;

  const CustomStepper({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final stepNumber = index + 1;
            final isActive = stepNumber <= currentStep;

            return Expanded(
              child: Row(
                children: [
                  // الدائرة
                  Container(
                    width: AppSizes.w40,
                    height: AppSizes.h40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? Colors.blue
                          : Colors.grey.shade300,
                    ),
                    child: Center(
                      child: Text(
                        "$stepNumber",
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // الخط
                  if (index != totalSteps - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        width: AppSizes.w50,
                        color: stepNumber < currentStep
                            ? Colors.blue
                            : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),

         SizedBox(height: AppSizes.h12),

        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        Text(
          "Step $currentStep of $totalSteps",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}