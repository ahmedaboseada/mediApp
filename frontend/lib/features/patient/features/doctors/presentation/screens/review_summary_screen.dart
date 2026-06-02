import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/widgets/common/app_button.dart';
import 'package:medi/features/patient/features/doctors/data/models/appointment_review_data.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/booking_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/review_summary_doctor_header.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewSummaryScreen extends StatelessWidget {
  const ReviewSummaryScreen({super.key, this.reviewData});

  final AppointmentReviewData? reviewData;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BookingCubit, BookingState>(
          listenWhen: (previous, current) =>
              previous.paymentUrl != current.paymentUrl &&
              current.paymentUrl != null,
          listener: (context, state) {
            getIt<PaymentFlowCache>().setPendingReviewData(
              state.appointmentReviewData,
            );
            _launchPaymentUrl(context, state.paymentUrl!);
          },
        ),
        BlocListener<BookingCubit, BookingState>(
          listenWhen: (previous, current) =>
              previous.isBooking &&
              !current.isBooking &&
              current.appointmentReviewData.paymentMethod.toLowerCase() ==
                  'cash',
          listener: (context, state) {
            if (state.bookingSuccess) {
              context.go(
                AppRouter.patientPaymentSuccessScreen,
                extra: state.appointmentReviewData,
              );
              return;
            }

            context.go(
              AppRouter.patientPaymentFailureScreen,
              extra: state.bookingErrorMessage ??
                  'Booking could not be completed. Please try again.',
            );
          },
        ),
      ],
      child: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          final data = state.appointmentReviewData;
          final isCashPayment = data.paymentMethod.toLowerCase() == 'cash';

          return Scaffold(
            appBar: const CustomAppBar(title: 'Review Summary'),
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w16,
                  vertical: AppSizes.h12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ReviewSummaryDoctorHeader(
                              doctor: data.doctor!,
                              location: data.location,
                            ),
                            SizedBox(height: AppSizes.h14),
                            Divider(color: AppColors.borderColor),
                            SizedBox(height: AppSizes.h6),
                            _SummaryRow(
                              title: 'Date & Hour',
                              value: data.dateAndHour,
                            ),
                            _SummaryRow(
                              title: 'Package',
                              value: data.packageName,
                            ),
                            _SummaryRow(
                              title: 'Duration',
                              value: data.duration,
                            ),
                            _SummaryRow(
                              title: 'Booking for',
                              value: data.bookingFor,
                            ),
                            SizedBox(height: AppSizes.h8),
                            Divider(color: AppColors.borderColor),
                            SizedBox(height: AppSizes.h6),
                            _SummaryRow(
                              title: 'Amount',
                              value: '${data.amount.toStringAsFixed(0)} EGP',
                            ),
                           
                            _SummaryRow(
                              title: 'Duration',
                              value: data.duration,
                            ),
                            SizedBox(height: AppSizes.h8),
                            Divider(color: AppColors.borderColor),
                            SizedBox(height: AppSizes.h6),
                            _SummaryRow(
                              title: 'Total',
                              value: '${data.amount.toStringAsFixed(0)} EGP',
                            ),
                            SizedBox(height: AppSizes.h12),
                            Row(
                              children: [
                                Icon(
                                  Icons.credit_card_rounded,
                                  color: AppColors.primary,
                                  size: AppSizes.sp18,
                                ),
                                SizedBox(width: AppSizes.w8),
                                Expanded(
                                  child: Text(
                                    data.paymentMethod,
                                    style: AppStyles.black14500.copyWith(
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.push(
                                      AppRouter.patientPaymentMethodScreen,
                                    );
                                  },
                                  child: const Text(
                                    'Change',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.h16),
                    AppButton(
                      isLoading: state.isBooking,
                      onPressed: state.isBooking
                          ? null
                          : () {
                              if (isCashPayment) {
                                context.read<BookingCubit>().createBooking();
                                return;
                              }

                              context.read<BookingCubit>().initiatePayment();
                            },
                      text: isCashPayment ? 'Confirm' : 'Pay Now',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _launchPaymentUrl(
    BuildContext context,
    String paymentUrl,
  ) async {
    final paymentUri = Uri.parse(paymentUrl);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final launched = await launchUrl(
      paymentUri,
      mode: LaunchMode.externalApplication,
    );

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      context.read<BookingCubit>().clearPaymentUrl();
    }

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open the payment page.')),
      );
    }
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.h6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppStyles.secondary12400.copyWith(fontSize: AppSizes.sp16),
            ),
          ),
          Text(value, style: AppStyles.black14500),
        ],
      ),
    );
  }
}
