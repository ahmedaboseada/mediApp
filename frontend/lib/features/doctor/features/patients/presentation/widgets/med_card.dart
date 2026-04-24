import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_model.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/medicine_stock_row.dart';

class MedCard extends StatelessWidget {
  const MedCard({super.key, required this.medication, this.onTap});

  final MedicationModel medication;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isCritical = medication.status.toLowerCase() == 'critical';

    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.r20),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.all(AppSizes.w16),
        decoration: BoxDecoration(
          color: isCritical
              ? AppColors.medicineCriticalCardBackground
              : AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(AppSizes.r20),
          border: Border.all(
            color: isCritical
                ? AppColors.medicineCriticalCardBorder
                : AppColors.cardBorderColor,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MedicationHeader(type: medication.type ?? 'pill'),
            SizedBox(width: AppSizes.w12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MedicationInfoRow(medication: medication),
                  SizedBox(height: AppSizes.h8),
                  MedicationStockRow(medication: medication),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicationHeader extends StatelessWidget {
  const MedicationHeader({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final Widget icon = switch (type.toLowerCase()) {
      'syringe' || 'injection' => SvgPicture.asset(
        AppAssets.syringe,
        width: AppSizes.w24,
        height: AppSizes.h24,
        fit: BoxFit.contain,
      ),
      'bottle' || 'syrup' => SvgPicture.asset(
        AppAssets.syrupIcon,
        width: AppSizes.w24,
        height: AppSizes.h24,
      ),
      'tablet' => Image.asset(
        AppAssets.tabletIcon,
        width: AppSizes.w24,
        height: AppSizes.h24,
        fit: BoxFit.contain,
      ),
      'pill' || 'pills' => SvgPicture.asset(
        AppAssets.tabletIcon,
        width: AppSizes.w24,
        height: AppSizes.h24,
      ),
      'cream' => SvgPicture.asset(
        AppAssets.medicineCream,
        width: AppSizes.w24,
        height: AppSizes.h24,
      ),
      'drop' || 'drops' => SvgPicture.asset(
        AppAssets.medicineDrop,
        width: AppSizes.w24,
        height: AppSizes.h24,
      ),
      'inhaler' => SvgPicture.asset(
        AppAssets.medicineInhaler,
        width: AppSizes.w24,
        height: AppSizes.h24,
      ),
      'ointment' => SvgPicture.asset(
        AppAssets.medicineOintment,
        width: AppSizes.w24,
        height: AppSizes.h24,
      ),
      _ => SvgPicture.asset(
        AppAssets.tabletIcon, // Default fallback
        width: AppSizes.w24,
        height: AppSizes.h24,
      ),
    };

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: AppSizes.h4),
        child: icon,
      ),
    );
  }
}

class MedicationInfoRow extends StatelessWidget {
  const MedicationInfoRow({super.key, required this.medication});

  final MedicationModel medication;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                medication.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: AppStyles.black18500.copyWith(
                  fontSize: AppSizes.sp28 * 0.75,
                ),
              ),
            ),
            if (medication.status.toLowerCase() == 'critical')
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w8,
                  vertical: AppSizes.h4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.medicineCriticalBadgeBackground,
                  borderRadius: BorderRadius.circular(AppSizes.r80),
                ),
                child: Text(
                  AppStrings.critical,
                  style: AppStyles.white14500.copyWith(fontSize: AppSizes.sp12),
                ),
              ),
          ],
        ),
        Text(
          '${medication.dosage} - ${medication.frequency}',
          style: AppStyles.secondary12400.copyWith(fontSize: AppSizes.sp14),
        ),
      ],
    );
  }
}

class MedicationStockRow extends StatelessWidget {
  const MedicationStockRow({super.key, required this.medication});

  final MedicationModel medication;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [MedicineStockRow(stock: medication.stock)],
    );
  }
}
