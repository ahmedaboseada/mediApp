import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/custom_stepper.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool _isLoading = false;

  void _handleAddMedication() {
    // TODO: Call API to add medication
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      
      // Navigate to success screen or back to home
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medication added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primaryText),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Add Medication',
          style: AppStyles.black16400.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w16,
              vertical: AppSizes.h16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Progress Stepper
                CustomStepper(
                  currentStep: 5,
                  title: 'Confirmation',
                ),
                SizedBox(height: AppSizes.h32),

                // Medication Summary Section
                _buildSummaryCard(
                  title: 'Medication',
                  items: [
                    _buildSummaryItem('Medication name', 'Medication name'),
                    _buildSummaryItem('Dosage', 'Not specified'),
                    _buildSummaryItem('Frequency', 'Every day'),
                    _buildSummaryItem('Stock', 'Not specified units'),
                  ],
                ),
                SizedBox(height: AppSizes.h16),

                // Schedule & Dates Summary Section
                _buildSummaryCard(
                  title: 'Schedule & Dates',
                  items: [
                    _buildSummaryItem('Start/end date', '12/2/2026 - 12/3/2026'),
                    _buildSummaryItem('Expiration date', '30/7/2026'),
                  ],
                ),
                SizedBox(height: AppSizes.h16),

                // Reminders Summary Section
                _buildSummaryCard(
                  title: 'Reminders set',
                  items: [
                    _buildSummaryItem('Time', '7 Am\n7 Pm'),
                  ],
                ),
                SizedBox(height: AppSizes.h16),

                // Critical Mode Status
                Container(
                  padding: EdgeInsets.all(AppSizes.w12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.r10),
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: const Color(0xFF10B981),
                        size: AppSizes.w20,
                      ),
                      SizedBox(width: AppSizes.w12),
                      Expanded(
                        child: Text(
                          'No drug interactions detected',
                          style: AppStyles.black14500.copyWith(
                            color: const Color(0xFF10B981),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.h32),

                // Back and Add Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: AppSizes.h48,
                        child: PrimaryButton(
                          onPressed: () => context.pop(),
                          text: 'Back',
                          backgroundColor: AppColors.whiteText,
                          textColor: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: AppSizes.w12),
                    Expanded(
                      child: SizedBox(
                        height: AppSizes.h48,
                        child: PrimaryButton(
                          text: _isLoading ? 'Adding...' : 'Add Medication',
                          onPressed: _isLoading ? null : _handleAddMedication,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSizes.w16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.r10),
        border: Border.all(color: AppColors.borderColor),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.black16400.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.h12),
          ...List.generate(
            items.length,
            (index) => Column(
              children: [
                items[index],
                if (index < items.length - 1)
                  Divider(
                    color: AppColors.borderColor,
                    height: AppSizes.h12,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.h8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyles.secondary12400,
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppStyles.black14500,
            ),
          ),
        ],
      ),
    );
  }
}
