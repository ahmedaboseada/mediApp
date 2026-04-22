import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/doctors/data/models/appointment_review_data.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/booking_cubit.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key, this.initialData});

  final AppointmentReviewData? initialData;

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final FocusNode _cvvFocusNode = FocusNode();

  bool _saveCard = true;
  bool _showBackView = false;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    _cvvFocusNode.addListener(() {
      if (!mounted) return;
      setState(() => _showBackView = _cvvFocusNode.hasFocus);
    });

    _nameController.addListener(_updateCardDetails);
    _numberController.addListener(_updateCardDetails);
    _expiryController.addListener(_updateCardDetails);
    _cvvController.addListener(_updateCardDetails);
  }

  void _updateCardDetails() {
    context.read<BookingCubit>().updateCardDetails(
      cardHolderName: _nameController.text,
      cardNumber: _numberController.text,
      expiryDate: _expiryController.text,
      cvvCode: _cvvController.text,
    );
  }

  @override
  void dispose() {
    _cvvFocusNode.dispose();
    _nameController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Add Card'),
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w12,
                vertical: AppSizes.h8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _showBackView = !_showBackView),
                    onHorizontalDragEnd: (_) =>
                        setState(() => _showBackView = !_showBackView),
                    child: CreditCardWidget(
                      cardNumber: _numberController.text,
                      expiryDate: _expiryController.text,
                      cardHolderName: _nameController.text,
                      cvvCode: _cvvController.text,
                      showBackView: _showBackView,
                      onCreditCardWidgetChange: (_) {},
                      bankName: 'VISA',
                      cardBgColor: AppColors.primary,
                      isHolderNameVisible: true,
                      isChipVisible: true,
                      obscureCardNumber: false,
                      obscureCardCvv: false,
                      labelCardHolder: 'Card holder name',
                      labelExpiredDate: 'Expiry date',
                      isSwipeGestureEnabled: true,
                    ),
                  ),
                  SizedBox(height: AppSizes.h14),
                  CustomTextField(
                    label: 'Card Holder Name',
                    controller: _nameController,
                    hintText: 'Esther Howard',
                    textInputAction: TextInputAction.next,
                    onTap: () => setState(() => _showBackView = false),
                  ),
                  SizedBox(height: AppSizes.h14),
                  CustomTextField(
                    label: 'Card Number',
                    controller: _numberController,
                    hintText: '4716 9627 1635 8047',
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onTap: () => setState(() => _showBackView = false),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CardNumberFormatter(),
                    ],
                  ),
                  SizedBox(height: AppSizes.h14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              label: 'Expiry Date',
                              controller: _expiryController,
                              hintText: '02/30',
                              keyboardType: TextInputType.datetime,
                              textInputAction: TextInputAction.next,
                              onTap: () =>
                                  setState(() => _showBackView = false),
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter,
                                _ExpiryDateFormatter(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppSizes.w12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              label: 'CVV',
                              controller: _cvvController,
                              focusNode: _cvvFocusNode,
                              hintText: '000',
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.h8),
                  Row(
                    children: [
                      Checkbox(
                        value: _saveCard,
                        activeColor: AppColors.primary,
                        side: BorderSide(color: AppColors.borderColor),
                        onChanged: (value) {
                          setState(() => _saveCard = value ?? false);
                        },
                      ),
                      Text('Save Card', style: AppStyles.black14500),
                    ],
                  ),
                  SizedBox(height: AppSizes.h20),
                  PrimaryButton(
                    text: 'Add Card',
                    onPressed: () {
                      final data = state.appointmentReviewData.copyWith(
                        paymentMethod: 'Card',
                      );
                      context.push(
                        AppRouter.patientReviewSummaryScreen,
                        extra: data,
                      );
                    },
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

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final clipped = digits.length > 4 ? digits.substring(0, 4) : digits;
    final buffer = StringBuffer();
    for (int i = 0; i < clipped.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(clipped[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
