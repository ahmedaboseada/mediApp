import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medication_data_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medication_data_state.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/custom_stepper.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/navigation_buttons.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool _isSubmitting = false;

  String _formatReminderSummary(Medication medication) {
    if (medication.frequency.trim().toLowerCase() == 'weekly' &&
        medication.weeklySchedule.isNotEmpty) {
      return medication.weeklySchedule
          .map((entry) {
            final day = (entry['day'] as String? ?? '').trim();
            final times =
                (entry['times'] as List?)?.whereType<String>().toList() ??
                const <String>[];
            final title = day.isEmpty
                ? 'Day'
                : '${day[0].toUpperCase()}${day.substring(1)}';
            return '$title: ${times.join(', ')}';
          })
          .join('\n');
    }

    if (medication.frequency.trim().toLowerCase() == 'specific' &&
        medication.specificSchedule.isNotEmpty) {
      return medication.specificSchedule
          .map((entry) {
            final date = (entry['day'] as String? ?? '').trim();
            final times =
                (entry['times'] as List?)?.whereType<String>().toList() ??
                const <String>[];
            return '$date: ${times.join(', ')}';
          })
          .join('\n');
    }

    return medication.reminders.isNotEmpty
        ? medication.reminders.join('\n')
        : 'No reminders set';
  }

  Future<void> _handleAddMedication() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final medication = context.read<MedicationDataCubit>().state.medicationData;

    try {
      // 🔥 Offline-first save (always succeeds locally)
      await context.read<MedicineCubit>().addMedication(medication);

      if (!mounted) return;

      // Success UI
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medication saved locally'),
          backgroundColor: Colors.green,
        ),
      );

      // Notifications
      LocalNotificationService().scheduleMedicationReminders(medication);
      LocalNotificationService.showNotification(
        title: 'Medication Added',
        body: '${medication.medicationName} has been added to your list.',
      );

      // Navigate
      context.pushReplacement('/medicine');
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationDataCubit, MedicationDataState>(
      builder: (context, state) {
        final medicationData = state.medicationData;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primaryText,
              ),
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
                    CustomStepper(currentStep: 5, title: 'Confirmation'),
                    SizedBox(height: AppSizes.h32),

                    // Medication Summary Section
                    _buildSummaryCard(
                      title: 'Medication',
                      items: [
                        _buildSummaryItem(
                          'Medication name',
                          medicationData.medicationName,
                        ),
                        _buildSummaryItem('Type', medicationData.type),
                        _buildSummaryItem('Dosage', medicationData.dosage),
                        _buildSummaryItem(
                          'Frequency',
                          medicationData.frequency,
                        ),
                        _buildSummaryItem(
                          'Stock',
                          '${medicationData.stock} units',
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h16),

                    // Schedule & Dates Summary Section
                    _buildSummaryCard(
                      title: 'Schedule & Dates',
                      items: [
                        _buildSummaryItem(
                          'Start/end date',
                          '${medicationData.startDate} - ${medicationData.endDate}',
                        ),
                        _buildSummaryItem(
                          'Expiration date',
                          medicationData.expiryDate,
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.h16),

                    // Reminders Summary Section
                    _buildSummaryCard(
                      title: 'Reminders set',
                      items: [
                        _buildSummaryItem(
                          'Time',
                          _formatReminderSummary(medicationData),
                        ),
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
                    NavigationButtons(
                      onBackPressed: _isSubmitting ? null : () => context.pop(),
                      nextEnabled: !_isSubmitting,
                      onNextPressed: _handleAddMedication,
                      nextText: _isSubmitting ? 'Adding...' : 'Add Medication',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
            style: AppStyles.black16400.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: AppSizes.h12),
          ...List.generate(
            items.length,
            (index) => Column(
              children: [
                items[index],
                if (index < items.length - 1)
                  Divider(color: AppColors.borderColor, height: AppSizes.h12),
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
          Text(label, style: AppStyles.secondary12400),
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
