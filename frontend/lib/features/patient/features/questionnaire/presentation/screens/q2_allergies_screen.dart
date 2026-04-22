import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/questionnaire/constants/constants.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_cubit.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_state.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/widgets/onboarding_progress.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/widgets/q_text_field_bool.dart';

class Q2AllergiesScreen extends StatefulWidget {
  const Q2AllergiesScreen({super.key});

  @override
  State<Q2AllergiesScreen> createState() => _Q2AllergiesScreenState();
}

class _Q2AllergiesScreenState extends State<Q2AllergiesScreen> {
  bool hasReactionToMedication = false;
  bool allergyAlerts = false;
  final TextEditingController _allergyOtherController = TextEditingController();
  List<String> _selectedAllergies = const <String>[];

  bool _containsOther(List<String> values) {
    return values.any((value) => value.trim().toLowerCase() == 'other');
  }

  List<String> _composeWithOther({
    required List<String> selected,
    required String otherValue,
  }) {
    final cleaned = selected
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty && value.toLowerCase() != 'other')
        .toList();

    final other = otherValue.trim();
    if (other.isNotEmpty) {
      cleaned.add(other);
    }

    return cleaned;
  }

  @override
  void dispose() {
    _allergyOtherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<QuestionnaireCubit>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: cubit.back,
        ),
      ),
      body: BlocConsumer<QuestionnaireCubit, QuestionnaireState>(
        listener: (context, state) {
          if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.h16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.hangTight,
                      style: AppStyles.primary70024.copyWith(
                        fontSize: AppSizes.sp22,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Image.asset(AppAssets.addInfo, height: AppSizes.h270),
                    QTextFieldBoolean(
                      onSelectionChange: (value) {
                        setState(() {
                          hasReactionToMedication = value;
                        });
                        cubit.updateAllergies(value);
                        print(value);
                      },
                      label: AppStrings.reactionToMedication,
                    ),
              
                    if (hasReactionToMedication) ...[
                      SizedBox(height: AppSizes.h16),
                      QTextField(
                        onSelectionChange: (List<String> selectedList) {
                          setState(() {
                            _selectedAllergies = selectedList;
                            if (!_containsOther(selectedList)) {
                              _allergyOtherController.clear();
                            }
                          });
                          cubit.updateAllergyList(
                            _composeWithOther(
                              selected: _selectedAllergies,
                              otherValue: _allergyOtherController.text,
                            ),
                          );
                          print(selectedList);
                        },
                        items: QuestionnaireConstants().allergies,
              
                        label: AppStrings.allergiesOrSensitivities,
                      ),
                      if (_containsOther(_selectedAllergies)) ...[
                        SizedBox(height: AppSizes.h8),
                        CustomTextField(
                          controller: _allergyOtherController,
                          onChanged: (_) {
                            cubit.updateAllergyList(
                              _composeWithOther(
                                selected: _selectedAllergies,
                                otherValue: _allergyOtherController.text,
                              ),
                            );
                          },
                          label: 'Please specify other allergy',
                          hintText: 'Please specify other allergy',
                        ),
                      ],
                    ],
              
                    SizedBox(height: AppSizes.h16),
                    QTextFieldBoolean(
                      singleSelect: true,
                      onSelectionChange: (value) {
                        setState(() {
                          allergyAlerts = value;
                        });
                        cubit.updateAllergyAlerts(value);
                        print(value);
                      },
              
                      label: AppStrings.allergyAlerts,
                    ),
                    SizedBox(height: AppSizes.h24),
                    const OnboardingProgress(step: 1),
                    SizedBox(height: AppSizes.h12),
                    PrimaryButton(
                      text: 'Next',
                      onPressed: state.isLoading
                          ? null
                          : () => cubit.completeHealthStep2(),
                      child: state.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    SizedBox(height: AppSizes.h12),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
