import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/home/data/repo/sos_repo.dart';
import 'package:medi/features/patient/features/home/presentation/controller/sos/sos_cubit.dart';

class SetEmergencyContactscreen extends StatefulWidget {
  const SetEmergencyContactscreen({super.key});

  @override
  State<SetEmergencyContactscreen> createState() =>
      _SetEmergencyContactscreenState();
}

class _SetEmergencyContactscreenState extends State<SetEmergencyContactscreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String selectedMethod = 'whatsapp';
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => SosCubit(getIt<SosRepo>()),
          child: BlocListener<SosCubit, SosState>(
            listener: (context, state) {
              if (state is EmergencyContactSetSuccess) {
                // Show success dialog
                _showSuccessDialog(context, state);
              } else if (state is SosFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.h24),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Close button
                    SizedBox(height: AppSizes.h16),

                    // Title
                    Text(
                      'Who should we contact\n in case of emergency?',
                      style: AppStyles.black24700,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSizes.h8),
                    Text(
                      "Add someone you trust. We'll send them \n an alert with your live location.",
                      style: AppStyles.secondary12400,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSizes.h24),

                    // Name field
                    SvgPicture.asset(AppAssets.setSos),
                    CustomTextField(
                      controller: nameController,
                      hintText: 'Enter name',
                      keyboardType: TextInputType.text,
                      label: 'Name',
                    ),
                    SizedBox(height: AppSizes.h20),

                    // Phone field
                    PhoneField(phonecontroller: phoneController),
                    SizedBox(height: AppSizes.h20),

                    // Contact method dropdown
                    SizedBox(height: AppSizes.h8),
                    CustomDropdown(
                      items: const ['whatsapp', 'sms'],
                      value: selectedMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value;
                        });
                      },
                      hint: 'Select',
                      label: 'Preferred Contact Method',
                    ),
                    SizedBox(height: AppSizes.h32),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: BlocBuilder<SosCubit, SosState>(
                            builder: (context, state) {
                              final isLoading = state is SosLoading;
                              return PrimaryButton(
                                text: 'Save',
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context
                                            .read<SosCubit>()
                                            .setEmergencyContact(
                                              name: nameController.text.trim(),
                                              phone: phoneController.text
                                                  .trim(),
                                              contactMethod: selectedMethod,
                                            );
                                      },
                                // isLoading: isLoading,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: AppSizes.w12),
                        Expanded(
                          child: BlocBuilder<SosCubit, SosState>(
                            builder: (context, state) {
                              final isLoading = state is SosLoading;
                              return SecondryButton(
                                text: 'Continue',
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context
                                            .read<SosCubit>()
                                            .setEmergencyContact(
                                              name: nameController.text.trim(),
                                              phone: phoneController.text
                                                  .trim(),
                                              contactMethod: selectedMethod,
                                            );
                                      },
                                // isLoading: isLoading,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(
    BuildContext context,
    EmergencyContactSetSuccess state,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r16),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.h32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Icon(
                  Icons.check_circle,
                  size: AppSizes.w48,
                  color: AppColors.success,
                ),
                SizedBox(height: AppSizes.h24),

                // Message
                Text(
                  'Saved successfully',
                  style: AppStyles.black18500.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h32),

                // Done button
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Done',
                    onPressed: () {
                      context.pop(); // Close success dialog
                      context.pop(); // Close main dialog
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
