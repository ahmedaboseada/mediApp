import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';

class RequestStatusScreen extends StatelessWidget {
  const RequestStatusScreen({
    super.key,
    required this.isConnected,
    required this.patientId,
    required this.onPrimaryAction,
  });

  final bool isConnected;
  final String patientId;
  final VoidCallback onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isConnected
        ? const Color(0xFF22C55E)
        : const Color(0xFFFF6B00);
    final Color iconBackground = isConnected
        ? const Color(0xFFE4F6EC)
        : const Color(0xFFF4E6DD);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w16,
            vertical: AppSizes.h12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.r40),
                  onTap: () => context.pop(),
                  child: Container(
                    width: AppSizes.w40,
                    height: AppSizes.w40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceColor,
                      borderRadius: BorderRadius.circular(AppSizes.r40),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h70),
              Center(
                child: Container(
                  width: AppSizes.w80,
                  height: AppSizes.w80,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isConnected ? Icons.check_circle_outline : Icons.schedule,
                    color: iconColor,
                    size: AppSizes.w40,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h24),
              Text(
                isConnected ? 'Successfully Connected!' : 'Pending Approval',
                style: AppStyles.black24700,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h8),
              Text(
                isConnected
                    ? 'You now have access to this patient\'s profile.'
                    : 'Waiting for patient (ID: $patientId) to approve your request',
                style: AppStyles.secondary12400,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.h24),
              if (!isConnected) ...[
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w16,
                      vertical: AppSizes.h10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B00),
                      borderRadius: BorderRadius.circular(AppSizes.r12),
                    ),
                    child: Text(
                      'Pending Doctor Approval',
                      style: AppStyles.white16600.copyWith(
                        fontSize: AppSizes.sp18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],

              SizedBox(height: AppSizes.h16),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w16,
                  vertical: AppSizes.h14,
                ),
                decoration: BoxDecoration(
                  color: isConnected
                      ? const Color(0xFFDCECE6)
                      : const Color(0xFFE9EBEF),
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                ),
                child: Column(
                  children: [
                    if (isConnected) ...[
                      Text(
                        'Access Granted',
                        style: AppStyles.black10600.copyWith(
                          fontSize: AppSizes.sp12,
                        ),
                      ),
                    ],
                    Text(
                      isConnected
                          ? 'This patient has been added to your list. You can reach him out now'
                          : 'The patient will receive a notification. This typically takes a few minutes.',
                      style: AppStyles.black14400.copyWith(
                        color: AppColors.primaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.h24),
              if (isConnected)
                PrimaryButton(onPressed: onPrimaryAction, text: 'View')
              else
                TextButton(
                  onPressed: onPrimaryAction,
                  child: Text(
                    'Cancel Request',
                    style: AppStyles.primary18700.copyWith(
                      color: const Color(0xFF98A1AF),
                    ),
                  ),
                ),
              const Spacer(),
              Align(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w16,
                    vertical: AppSizes.h12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(AppSizes.r12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 18,
                        color: Colors.black,
                      ),
                      SizedBox(width: AppSizes.w8),
                      Text(
                        isConnected
                            ? 'Patient approved your access request!'
                            : 'Access request sent to patient',
                        style: AppStyles.black14600.copyWith(
                          fontSize: AppSizes.sp14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h10),
            ],
          ),
        ),
      ),
    );
  }
}
