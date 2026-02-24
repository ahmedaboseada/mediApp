import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/core/widgets/q_text_fileld.dart';
import 'package:medi/features/doctor/constants/constants.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/q_flow/q_flow_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/widgets/q_progress_widget.dart';

class Q2SetAppointmentTypeScreen extends StatelessWidget {
  const Q2SetAppointmentTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            context.read<QFlowCubit>().back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.w16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSizes.h16),
                Text(
                  AppStrings.appointmentTypeTitle,
                  style: AppStyles.primary70024.copyWith(
                    fontSize: AppSizes.sp22,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSizes.h24),
                Image.asset(AppAssets.addInfo, height: AppSizes.h270),
                QTextField(
                  search: false,
                  onSelectionChange: (List<String> p1) {
                    print(p1);
                  },
                  items: DoctorConstants().appointmentsTypes,
                  label: 'What type of appointments do you offer?',
                ),
                SizedBox(height: AppSizes.h16),
                CustomTextField(
                  hintText: 'Max patients per day',
                  keyboardType: TextInputType.number,
                  label: 'Max patients per day',
                ),
                SizedBox(height: AppSizes.h24),
                const QProgressWidget(step: 1),

                SizedBox(height: AppSizes.h12),
                PrimaryButton(
                  text: AppStrings.done,
                  onPressed: () {
                    context.go(AppRouter.allowNotificationScreen);
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
