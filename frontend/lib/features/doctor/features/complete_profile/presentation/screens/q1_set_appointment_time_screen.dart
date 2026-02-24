import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/widgets/q_text_fileld.dart';
import 'package:medi/features/doctor/features/complete_profile/constants/constants.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/q_flow/q_flow_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/widgets/q_progress_widget.dart';

class Q1SetAppointmentTimeScreen extends StatelessWidget {
  const Q1SetAppointmentTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSizes.h16),
                Text(
                  AppStrings.appointmentAvailabilityTitle,
                  style: AppStyles.primary70024.copyWith(
                    fontSize: AppSizes.sp22,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h8),
                Text(
                  AppStrings.appointmentAvailabilitySubtitle,
                  style: AppStyles.tertiary14400,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h24),
                Image.asset(AppAssets.addInfo, height: AppSizes.h270),
                SizedBox(height: AppSizes.h24),
                QTextField(
                  label: AppStrings.workingDaysQuestion,
                  items: CompleteProfileConstants().workingDays,
                  onSelectionChange: (value) {
                    // TODO: wire selection to cubit or controller.
                  },
                ),
                SizedBox(height: AppSizes.h16),
                CustomDropdown(
                  label: AppStrings.consultationLengthLabel,
                  hint: AppStrings.selectTime,
                  items: AppStrings.consultationDurations,
                  onChanged: (value) {
                    print(value);
                  },
                ),
                InfoNoteWidget(text: AppStrings.appointmentScheduleNote),
                SizedBox(height: AppSizes.h24),
                const QProgressWidget(step: 0),
                SizedBox(height: AppSizes.h12),
                PrimaryButton(
                  text: AppStrings.next,
                  onPressed: () {
                    context.read<QFlowCubit>().next();
                  },
                ),
                SizedBox(height: AppSizes.h24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
