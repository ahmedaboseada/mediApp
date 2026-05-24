import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/booking_model.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/my_bookings_cubit.dart';

class CancelBookingScreen extends StatefulWidget {
  final BookingModel booking;
  final MyBookingsCubit cubit;
  const CancelBookingScreen({
    super.key,
    required this.booking,
    required this.cubit,
  });

  @override
  State<CancelBookingScreen> createState() => _CancelBookingScreenState();
}

class _CancelBookingScreenState extends State<CancelBookingScreen> {
  final TextEditingController _otherReasonController = TextEditingController();
  final List<String> _reasons = const [
    'Schedule Change',
    'Weather conditions',
    'Unexpected Work',
    'Childcare Issue',
    'Travel Delays',
    'Other',
  ];

  String _selectedReason = 'Schedule Change';

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  void _cancelAppointment() {
    final reason = _selectedReason == 'Other'
        ? _otherReasonController.text.trim()
        : _selectedReason;

    widget.cubit.cancelBooking(widget.booking.id, reason);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment cancelled successfully')),
    );
    context.pop();
  }

  void _showCancelConfirmationDialog() {
    final requiresOtherReason = _selectedReason == 'Other';
    final otherReason = _otherReasonController.text.trim();

    if (requiresOtherReason && otherReason.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your reason')));
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.surfaceColor,
          insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.w20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r20),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.w20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Appointment canceled',
                  style: AppStyles.black24700,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h10),

                SizedBox(height: AppSizes.h18),
                PrimaryButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    _cancelAppointment();
                  },
                  text: 'Book Another',
                ),
                TextButton(
                  onPressed: () {
                    _cancelAppointment();
                      context.push('/home');
                  },
                  child: Text('Go Home', style: AppStyles.secondary18500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Cancel Booking'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.w12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.h10),
              Text(
                'Please select the reason for cancellations:',
                style: AppStyles.secondary12400,
              ),
              SizedBox(height: AppSizes.h12),
              RadioGroup<String>(
                groupValue: _selectedReason,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedReason = value;
                  });
                },
                child: Column(
                  children: _reasons
                      .map(
                        (reason) => Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedReason = reason;
                              });
                            },
                            borderRadius: BorderRadius.circular(AppSizes.r8),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: AppSizes.h4,
                              ),
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: reason,
                                    activeColor: AppColors.primary,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  SizedBox(width: AppSizes.w4),
                                  Expanded(
                                    child: Text(
                                      reason,
                                      style: AppStyles.black16400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: AppSizes.h4),
              CustomTextField(
                label: 'Other',
                hintText: 'Enter your Reason',
                controller: _otherReasonController,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
              ),
              SizedBox(height: AppSizes.h24),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: _showCancelConfirmationDialog,
                  child: Text(
                    'Cancel Appointment',
                    style: AppStyles.white16600,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h8),
            ],
          ),
        ),
      ),
    );
  }
}
