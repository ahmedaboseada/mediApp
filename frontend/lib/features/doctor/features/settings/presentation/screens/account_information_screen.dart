import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/constants/constants.dart';
import 'package:medi/features/patient/questionnaire/presentation/widgets/q_text_fileld.dart';

class AccountInformationScreen extends StatelessWidget {
  AccountInformationScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.w16),
            child: Card(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w16,
                  vertical: AppSizes.h16,
                ),

                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Account Information',
                        style: AppStyles.fieldLabel50014.copyWith(
                          fontSize: AppSizes.sp18,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: AppSizes.h24),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              autofillHints: const [AutofillHints.name],
                              hintText: AppStrings.firstNameHint,
                              controller: _nameController,
                              validator: (value) => value.validateFirstName(),
                              label: AppStrings.firstNameHint,
                            ),
                          ),
                          SizedBox(width: AppSizes.w16),
                          Expanded(
                            child: CustomTextField(
                              autofillHints: const [AutofillHints.name],
                              hintText: AppStrings.lastNameHint,
                              controller: _lastNameController,
                              validator: (value) => value.validateLastName(),
                              label: AppStrings.lastNameHint,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.h24),
                      CustomTextField(
                        autofillHints: const [AutofillHints.email],
                        hintText: AppStrings.emailHint,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value.validateEmail(),
                        label: AppStrings.emailHint,
                      ),
                      SizedBox(height: AppSizes.h24),
                      const PhoneField(),
                      SizedBox(height: AppSizes.h24),

                      QTextField(
                        onSelectionChange: (value) {
                          print(value);
                        },
                        items: DoctorConstants().spicilizations,
                        label: "Specialization",
                      ),
                      SizedBox(height: AppSizes.h24),
                      CustomTextField(
                        hintText: AppStrings.clinicHospitalName,
                        label: AppStrings.clinicHospitalName,
                      ),
                      SizedBox(height: AppSizes.h24),
                      CustomTextField(
                        hintText: AppStrings.medicalLicenseNumber,
                        label: AppStrings.medicalLicenseNumber,
                      ),
                      SizedBox(height: AppSizes.h24),
                      const GenderField(),
                      SizedBox(height: AppSizes.h24),
                      PrimaryButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Process the data
                          }
                        },
                        text: 'Save ',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
