import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/current_stock_field.dart';

Future<void> showRefillStockDialog(
  BuildContext context, {
  required ValueChanged<int> onSave,
}) async {
  final currentStockController = TextEditingController();

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        constraints: BoxConstraints(maxWidth: double.infinity),
        backgroundColor: AppColors.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r16),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.all(AppSizes.w16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Refilling',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppSizes.sp20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryText,
                    ),
                  ),
                  SizedBox(height: AppSizes.h16),
                  Text(
                    'Add stock',
                    style: TextStyle(
                      fontSize: AppSizes.sp16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryText,
                    ),
                  ),
                  SizedBox(height: AppSizes.h8),
                  CurrentStockField(
                    controller: currentStockController,
                    onIncrement: () {
                      final currentValue =
                          int.tryParse(currentStockController.text) ?? 0;
                      setState(() {
                        currentStockController.text = (currentValue + 1)
                            .toString();
                      });
                    },
                    onDecrement: () {
                      final currentValue =
                          int.tryParse(currentStockController.text) ?? 0;
                      if (currentValue > 0) {
                        setState(() {
                          currentStockController.text = (currentValue - 1)
                              .toString();
                        });
                      }
                    },
                  ),
                  SizedBox(height: AppSizes.h20),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          onPressed: () {
                            onSave(
                              int.tryParse(currentStockController.text) ?? 0,
                            );
                            Navigator.of(dialogContext).pop();
                          },
                          text: 'Save',
                        ),
                      ),
                      SizedBox(width: AppSizes.w12),
                      Expanded(
                        child: PrimaryButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          text: 'Cancel',
                          backgroundColor: AppColors.secondary,
                          textColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
