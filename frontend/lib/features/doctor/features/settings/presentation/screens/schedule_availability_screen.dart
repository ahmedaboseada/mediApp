import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/constants/constants.dart';
import 'package:medi/features/doctor/features/settings/presentation/widgets/working_days_widget.dart';
import 'package:medi/features/patient/questionnaire/presentation/widgets/q_text_fileld.dart';

class ScheduleAvailabilityScreen extends StatelessWidget {
  const ScheduleAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.w16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: AppSizes.h24),
                    Text(
                      'Schedule & Availability',
                      style: AppStyles.fieldLabel50014.copyWith(
                        fontSize: AppSizes.sp18,
                      ),
                    ),
                    SizedBox(height: AppSizes.h24),
                    Text(
                      'Working Days',
                      style: AppStyles.bodyText.copyWith(
                        fontSize: AppSizes.sp16,
                      ),
                    ),
                    Text(
                      'Select the days you\'re available for appointments',
                      style: AppStyles.dividerText40012,
                    ),
                    SizedBox(height: AppSizes.h16),
                    WorkingDaysWidget(),
                    SizedBox(height: AppSizes.h24),
                    CustomDropdown(
                      label: 'How long is each consultation?',
                      hint: 'Select Time',
                      items: ['15 min', '30 min', '45 min', '60 min'],
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    SizedBox(height: AppSizes.h16),
                    QTextField(
                      label: 'What are your working hours?',
                      hint: 'Select Time',
                      items: DoctorConstants().workingHours,

                      onSelectionChange: (List<String> p1) {
                        print(p1);
                      },
                    ),
                    SizedBox(height: AppSizes.h16),
                    QTextField(
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
                    PrimaryButton(
                      onPressed: () {
                        // Save the schedule and availability settings
                      },
                      text: 'Save',
                    ),
                    SizedBox(height: AppSizes.h24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
