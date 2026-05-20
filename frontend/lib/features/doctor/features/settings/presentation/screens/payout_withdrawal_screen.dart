import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/settings/presentation/controller/cubit/wallet_cubit.dart';
import 'package:medi/features/doctor/features/settings/presentation/widgets/balance_container.dart';

class PayoutWithdrawalScreen extends StatefulWidget {
  const PayoutWithdrawalScreen({super.key});

  @override
  State<PayoutWithdrawalScreen> createState() => _PayoutWithdrawalScreenState();
}

class _PayoutWithdrawalScreenState extends State<PayoutWithdrawalScreen> {
  final _bankNameController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountHolderNameController.dispose();
    _accountNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WalletCubit>()..loadWallet(),
      child: BlocConsumer<WalletCubit, WalletState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.message != current.message,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }

          if (state.message != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message!)));
            context.read<WalletCubit>().clearMessage();
            _amountController.clear();
          }
        },
        builder: (context, state) {
          final isLoading = state.status == WalletStatus.loading;
          final isSubmitting = state.status == WalletStatus.submitting;

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
                                BalanceContainer(
                                  balance: isLoading
                                      ? 'Loading...'
                                      : '${state.balance.toStringAsFixed(2)} EGP',
                                ),
                                SizedBox(height: AppSizes.h24),
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
                                CustomTextField(
                                  label: 'Account Holder Name',
                                  controller: _accountHolderNameController,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter account holder name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: AppSizes.h24),
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
                                CustomTextField(
                                  label: 'Amount',
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter amount';
                                    }

                                    final amount = double.tryParse(value);
                                    if (amount == null || amount <= 0) {
                                      return 'Please enter a valid amount';
                                    }

                                    if (amount > state.balance) {
                                      return 'Amount exceeds available balance';
                                    }

                                    return null;
                                  },
                                ),
                                SizedBox(height: AppSizes.h24),
                                SizedBox(
                                  width: double.infinity,
                                  height: AppSizes.h48,
                                  child: PrimaryButton(
                                    text: isSubmitting
                                        ? 'Submitting...'
                                        : 'Request Withdrawal',
                                    onPressed: (isSubmitting || isLoading)
                                        ? null
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context
                                                  .read<WalletCubit>()
                                                  .requestWithdrawal(
                                                    bankName:
                                                        _bankNameController.text
                                                            .trim(),
                                                    accountNumber:
                                                        _accountNumberController
                                                            .text
                                                            .trim(),
                                                    accountHolderName:
                                                        _accountHolderNameController
                                                            .text
                                                            .trim(),
                                                    amount: double.parse(
                                                      _amountController.text
                                                          .trim(),
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
        },
      ),
    );
  }
}
