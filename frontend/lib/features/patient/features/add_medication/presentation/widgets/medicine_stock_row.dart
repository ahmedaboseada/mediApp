import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/medicine_status_badge.dart';

class MedicineStockRow extends StatelessWidget {
  const MedicineStockRow({
    super.key,
    required this.stock,
    required this.stockStatus,
  });

  final int stock;
  final MedicationStockStatus stockStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.account_box,
          color: AppColors.secondaryText,
          size: 18,
        ),
        SizedBox(width: AppSizes.w4),
        Text(
          '${AppStrings.stock} $stock',
          style: AppStyles.secondary12400.copyWith(fontSize: AppSizes.sp12),
        ),
        SizedBox(width: AppSizes.w8),
        MedicineStatusBadge(status: stockStatus),
      ],
    );
  }
}
