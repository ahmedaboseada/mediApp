import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/utils/safe_go_router.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/profile/profile_cubit.dart';

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _currentEmailController;
  late TextEditingController _newEmailController;
  late TextEditingController _confirmEmailController;

  @override
  void initState() {
    super.initState();
    _currentEmailController = TextEditingController();
    _newEmailController = TextEditingController();
    _confirmEmailController = TextEditingController();
    _loadCurrentEmail();
  }

  Future<void> _loadCurrentEmail() async {
    final email = HiveService.getEmail();
    if (mounted) {
      setState(() {
        _currentEmailController.text = email ?? 'Ahmed14@email.com';
      });
    }
  }

  @override
  void dispose() {
    _currentEmailController.dispose();
    _newEmailController.dispose();
    _confirmEmailController.dispose();
    super.dispose();
  }

  Future<void> _changeEmail(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileCubit>().requestEmailChange(
        newEmail: _newEmailController.text.trim(),
      );
    }
  }

  void _showChangeEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: Dialog(
          clipBehavior: Clip.hardEdge,
          constraints: const BoxConstraints(maxWidth: double.infinity),
          insetPadding: EdgeInsets.all(AppSizes.w16),
          backgroundColor: AppColors.whiteText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r40),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.w24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Change Email',
                  style: AppStyles.black24700,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h16),

                // Message
                Text(
                  "We've sent a confirmation link to your new email\nPlease confirm to complete the change",
                  style: AppStyles.tertiary14400,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h32),

                // Okay Button
                PrimaryButton(
                  onPressed: () {
                   // _changeEmail(context);
                    Navigator.pop(dialogContext);
                  },
                  text: 'Okay',
                ),
                SizedBox(height: AppSizes.h12),

                // Cancel Button
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    final isLoading = state is CancelEmailChangeLoading;
                    return SecondryButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<ProfileCubit>().cancelEmailChange();
                            },
                      text: isLoading ? 'Cancelling...' : 'Cancel',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is RequestEmailChangeSuccess) {
              context.showSafeSnackBar(state.message);
              _showChangeEmailDialog(context);
            } else if (state is RequestEmailChangeFailure) {
              context.showSafeSnackBar(state.message);
            } else if (state is CancelEmailChangeSuccess) {
              context.showSafeSnackBar(state.message);
              Navigator.of(context).pop(); // Close dialog
            } else if (state is CancelEmailChangeFailure) {
              context.showSafeSnackBar(state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is RequestEmailChangeLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSizes.w16),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.w24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        Text(
                          'Security & Privacy',
                          style: AppStyles.black14500.copyWith(
                            fontSize: AppSizes.sp18,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: AppSizes.h24),

                        // Current Email Field (Read-only)
                        CustomTextField(
                          hintText: 'Current email',
                          label: 'Email',
                          controller: _currentEmailController,
                          readOnly: true,
                        ),
                        SizedBox(height: AppSizes.h24),

                        // New Email Field
                        CustomTextField(
                          hintText: 'Enter new email',
                          label: 'New Email',
                          controller: _newEmailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value.validateEmail(),
                        ),
                        SizedBox(height: AppSizes.h24),

                        // Confirm Email Field
                        CustomTextField(
                          hintText: 'Confirm new email',
                          label: 'Confirm Email',
                          controller: _confirmEmailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => value.validateConfirmEmail(
                            _newEmailController.text,
                          ),
                        ),
                        SizedBox(height: AppSizes.h24),

                        // Change Email Button
                        PrimaryButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                             // _showChangeEmailDialog(context);
                              _changeEmail(context);
                            }
                          },
                          text: isLoading ? 'Requesting...' : 'Change Email',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
