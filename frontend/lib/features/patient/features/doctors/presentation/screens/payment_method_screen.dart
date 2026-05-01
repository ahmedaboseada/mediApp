import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/appointment_review_data.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/booking_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/widgets/payment_option_tile.dart';

enum _PaymentMethod { card, paypal, applePay }

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key, this.initialData});

  final AppointmentReviewData? initialData;

  void _handleNext(BuildContext context, BookingState state) {
    final paymentMethod = _getPaymentMethod(state.selectedPaymentMethod);
    switch (paymentMethod) {
      case _PaymentMethod.card:
        context.read<BookingCubit>().updatePaymentMethod('Card');
        context.push(
          AppRouter.patientReviewSummaryScreen,
          extra: state.appointmentReviewData.copyWith(paymentMethod: 'Card'),
        );
        break;
      case _PaymentMethod.paypal:
      case _PaymentMethod.applePay:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This payment method is coming soon')),
        );
        break;
    }
  }

  _PaymentMethod _getPaymentMethod(String value) {
    switch (value) {
      case 'paypal':
        return _PaymentMethod.paypal;
      case 'applePay':
        return _PaymentMethod.applePay;
      default:
        return _PaymentMethod.card;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final selectedMethod = _getPaymentMethod(state.selectedPaymentMethod);
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
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      if (value == null) return;
                      final methodString = value == _PaymentMethod.card
                          ? 'card'
                          : value == _PaymentMethod.paypal
                          ? 'paypal'
                          : 'applePay';
                      context.read<BookingCubit>().updatePaymentMethod(
                        methodString,
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
                        ),
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
                          child: Column(
                            children: [
                              PaymentOptionTile<_PaymentMethod>(
                                title: 'Paypal',
                                leading: SvgPicture.asset(
                                  AppAssets.paypal,
                                  width: AppSizes.w20,
                                  height: AppSizes.h20,
                                ),
                                value: _PaymentMethod.paypal,
                                hasBorder: true,
                              ),
                              Divider(color: AppColors.borderColor),
                              PaymentOptionTile<_PaymentMethod>(
                                leading: SvgPicture.asset(
                                  AppAssets.apple,
                                  width: AppSizes.w20,
                                  height: AppSizes.h20,
                                ),
                                hasBorder: true,
                                title: 'Apple Pay',
                                value: _PaymentMethod.applePay,
                              ),
                            ],
                          ),
                        ),
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
