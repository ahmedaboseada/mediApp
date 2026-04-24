import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/questionnaire/constants/constants.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_cubit.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_state.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/widgets/onboarding_progress.dart';

class Q1HealthScreen extends StatefulWidget {
  const Q1HealthScreen({super.key});

  @override
  State<Q1HealthScreen> createState() => _Q1HealthScreenState();
}

class _Q1HealthScreenState extends State<Q1HealthScreen> {
  final TextEditingController _healthOtherController = TextEditingController();
  final TextEditingController _medicationOtherController =
      TextEditingController();

  List<String> _selectedHealthConditions = const <String>[];
  List<String> _selectedMedications = const <String>[];

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

  void _onHealthSelectionChanged(
    QuestionnaireCubit cubit,
    List<String> selectedList,
  ) {
    setState(() {
      _selectedHealthConditions = selectedList;
      if (!_containsOther(selectedList)) {
        _healthOtherController.clear();
      }
    });

    cubit.updateHealthConditions(
      _composeWithOther(
        selected: _selectedHealthConditions,
        otherValue: _healthOtherController.text,
      ),
    );
  }

  void _onMedicationSelectionChanged(
    QuestionnaireCubit cubit,
    List<String> selectedList,
  ) {
    setState(() {
      _selectedMedications = selectedList;
      if (!_containsOther(selectedList)) {
        _medicationOtherController.clear();
      }
    });

    cubit.updateMedications(
      _composeWithOther(
        selected: _selectedMedications,
        otherValue: _medicationOtherController.text,
      ),
    );
  }

  @override
  void dispose() {
    _healthOtherController.dispose();
    _medicationOtherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<QuestionnaireCubit, QuestionnaireState>(
        listener: (context, state) {
          if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          final cubit = context.read<QuestionnaireCubit>();
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.h16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.letsLearnMoreAboutYourHealth,
                      style: AppStyles.primary70024.copyWith(
                        fontSize: AppSizes.sp22,
                      ),
                    ),
                    Image.asset(AppAssets.addInfo, height: AppSizes.h270),

                    QTextField(
                      onSelectionChange: (selectedList) =>
                          _onHealthSelectionChanged(cubit, selectedList),
                      items: QuestionnaireConstants().healthConditions,

                      label: AppStrings.anyHealthConditionsYouLikeToShare,
                    ),
                    if (_containsOther(_selectedHealthConditions)) ...[
                      SizedBox(height: AppSizes.h8),
                      CustomTextField(
                        controller: _healthOtherController,
                        onChanged: (_) {
                          cubit.updateHealthConditions(
                            _composeWithOther(
                              selected: _selectedHealthConditions,
                              otherValue: _healthOtherController.text,
                            ),
                          );
                        },
                        label: ' Please specify other health condition',
                        hintText: 'Please specify other health condition',
                      ),
                    ],

                    SizedBox(height: AppSizes.h16),

                    QTextField(
                      onSelectionChange: (selectedList) =>
                          _onMedicationSelectionChanged(cubit, selectedList),
                      items: QuestionnaireConstants().longTermMedications,
                      label: AppStrings
                          .areYouCurrentlyTakingAnyLongTermMedications,
                    ),
                    if (_containsOther(_selectedMedications)) ...[
                      SizedBox(height: AppSizes.h8),
                      CustomTextField(
                        controller: _medicationOtherController,
                        onChanged: (_) {
                          cubit.updateMedications(
                            _composeWithOther(
                              selected: _selectedMedications,
                              otherValue: _medicationOtherController.text,
                            ),
                          );
                        },
                        label: ' Please specify other medication',
                      ),
                    ],

                    SizedBox(height: AppSizes.h86),
                    const OnboardingProgress(step: 0),
                    SizedBox(height: AppSizes.h12),
                    PrimaryButton(
                      text: 'Next',
                      onPressed: state.isLoading
                          ? null
                          : () => cubit.completeHealthStep1(),
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
                    SizedBox(height: AppSizes.h16),
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
