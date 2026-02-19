import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/settings/presentation/widgets/balance_container.dart';

class PayoutWithdrawalScreen extends StatelessWidget {
  PayoutWithdrawalScreen({super.key});

  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.w24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card with title
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.w16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payout & Withdrawal',
                            style: AppStyles.primary18700,
                          ),
                          SizedBox(height: AppSizes.h24),
                          BalanceContainer(balance: '\$2,500.00'),
                          SizedBox(height: AppSizes.h24),

                          // Bank Name Field
                          CustomTextField(
                            label: 'Bank Name',
                            controller: _bankNameController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter bank name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSizes.h24),

                          // Account Number Field
                          CustomTextField(
                            label: 'Account Number',
                            controller: _accountNumberController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter account number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: AppSizes.h24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: AppSizes.h48,
                            child: PrimaryButton(
                              text: 'Save ',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Handle form submission
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Details saved successfully',
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
