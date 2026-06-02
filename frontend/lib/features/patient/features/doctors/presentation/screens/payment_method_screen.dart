import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/services/accessibility_service.dart';
import 'package:medi/features/patient/features/doctors/data/models/appointment_review_data.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/booking_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/payment_option_tile.dart';

enum _PaymentMethod { card, cash }

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key, this.initialData});

  final AppointmentReviewData? initialData;

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  bool _announced = false;

  bool _isOfflinePackage(String packageName) {
    final normalized = packageName.trim().toLowerCase();
    return normalized == 'offline' || normalized == 'in-person';
  }

  _PaymentMethod _getPaymentMethod(String value) {
    final normalized = value.trim().toLowerCase();
    switch (normalized) {
      case 'cash':
        return _PaymentMethod.cash;
      case 'card':
      default:
        return _PaymentMethod.card;
    }
  }

  String _getPaymentMethodValue(_PaymentMethod method) {
    return method == _PaymentMethod.cash ? 'cash' : 'card';
  }

  void _handleNext(BuildContext context, BookingState state) {
    final isOffline = _isOfflinePackage(state.appointmentReviewData.packageName);
    final paymentMethod = _getPaymentMethod(state.selectedPaymentMethod);

    if (paymentMethod == _PaymentMethod.cash && !isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cash payment is only available for offline appointments'),
        ),
      );
      return;
    }

    final paymentMethodLabel = paymentMethod == _PaymentMethod.cash
        ? 'Cash'
        : 'Card';

    context.read<BookingCubit>().updatePaymentMethod(paymentMethodLabel);
    context.push(
      AppRouter.patientReviewSummaryScreen,
      extra: state.appointmentReviewData.copyWith(paymentMethod: paymentMethodLabel),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_announced) {
      _announced = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AccessibilityService.announceWithRTL('Payment method screen');
      });
    }

    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final isOffline = _isOfflinePackage(state.appointmentReviewData.packageName);
        final selectedMethod = _getPaymentMethod(state.selectedPaymentMethod);
        final groupValue = !isOffline && selectedMethod == _PaymentMethod.cash
            ? _PaymentMethod.card
            : selectedMethod;

        return Scaffold(
          appBar: const CustomAppBar(title: 'Payment Method'),
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
                  RadioGroup<_PaymentMethod>(
                    groupValue: groupValue,
                    onChanged: (value) {
                      if (value == null) return;
                      context.read<BookingCubit>().updatePaymentMethod(
                        _getPaymentMethodValue(value),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: AppSizes.h8),
                        Text(
                          'Credit & Debit Card',
                          style: AppStyles.black18500,
                        ),
                        SizedBox(height: AppSizes.h12),
                        PaymentOptionTile<_PaymentMethod>(
                          leading: SvgPicture.asset(
                            AppAssets.card,
                            width: AppSizes.w20,
                            height: AppSizes.h20,
                          ),
                          title: 'Add New Card',
                          value: _PaymentMethod.card,
                          semanticLabel: 'Add new card payment option',
                        ),
                        if (isOffline) ...[
                          SizedBox(height: AppSizes.h20),
                          Text(
                            'More Payment Options',
                            style: AppStyles.black18500,
                          ),
                          SizedBox(height: AppSizes.h12),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.surfaceColor,
                              borderRadius: BorderRadius.circular(AppSizes.r12),
                              border: Border.all(color: AppColors.borderColor),
                            ),
                            child: PaymentOptionTile<_PaymentMethod>(
                              title: 'Cash',
                              leading: const Icon(Icons.payments_outlined),
                              value: _PaymentMethod.cash,
                              hasBorder: true,
                              semanticLabel: 'Cash payment option',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: 'Next',
                    onPressed: () => _handleNext(context, state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
