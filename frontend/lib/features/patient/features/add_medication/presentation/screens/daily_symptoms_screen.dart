import 'package:flutter/material.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/daily_symptoms/daily_symptoms_action_buttons.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/daily_symptoms/daily_symptoms_notes_field.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/daily_symptoms/selected_symptoms_wrap.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/daily_symptoms/severity_section.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/daily_symptoms/symptom_selection_sheet.dart';

class DailySymptomsScreen extends StatefulWidget {
  const DailySymptomsScreen({super.key, this.medicationId = ''});

  final String medicationId;

  @override
  State<DailySymptomsScreen> createState() => _DailySymptomsScreenState();
}

class _DailySymptomsScreenState extends State<DailySymptomsScreen> {
  final TextEditingController _notesController = TextEditingController();
  final List<String> _selectedSymptoms = <String>[];

  double _severity = 0.5;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Add Daily Symptoms'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.w16,
              AppSizes.h12,
              AppSizes.w16,
              AppSizes.h24,
            ),
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(AppSizes.w20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Describe What You Feel',
                      style: AppStyles.black18500.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSizes.h16),
                    SelectedSymptomsWrap(
                      selectedSymptoms: _selectedSymptoms,
                      onRemove: (String symptom) {
                        setState(() {
                          _selectedSymptoms.remove(symptom);
                        });
                      },
                      onAddTap: _onAddSymptomTap,
                    ),
                    SizedBox(height: AppSizes.h24),
                    SeveritySection(
                      value: _severity,
                      onChanged: (double value) {
                        setState(() {
                          _severity = value;
                        });
                      },
                    ),
                    SizedBox(height: AppSizes.h20),
                    DailySymptomsNotesField(controller: _notesController),
                    SizedBox(height: AppSizes.h20),
                    DailySymptomsActionButtons(
                      onSave: _saveSymptoms,
                      onClear: () {
                        setState(() {
                          _notesController.clear();
                          _severity = 0.5;
                        });
                      },
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

  Future<void> _onAddSymptomTap() async {
    final String? selected = await showSymptomSelectionSheet(
      context,
      selectedSymptoms: _selectedSymptoms,
    );

    if (selected == null || _selectedSymptoms.contains(selected)) {
      return;
    }

    setState(() {
      _selectedSymptoms.add(selected);
    });
  }

  Future<void> _saveSymptoms() async {
    if (widget.medicationId.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing medication reference')),
      );
      return;
    }

    final repo = getIt<MedicineRepo>();
    final textParts = <String>[
      if (_selectedSymptoms.isNotEmpty) _selectedSymptoms.join(', '),
      if (_notesController.text.trim().isNotEmpty) _notesController.text.trim(),
    ];
    final text = textParts.isEmpty
        ? 'Daily symptoms logged'
        : textParts.join(' | ');

    final result = await repo.addDailyLog(
      medicationId: widget.medicationId,
      text: text,
      level: _severityLevel(_severity),
    );

    if (!mounted) return;

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      },
      (message) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        Navigator.of(context).pop();
      },
    );
  }

  String _severityLevel(double value) {
    if (value < 0.34) {
      return 'low';
    }
    if (value < 0.67) {
      return 'medium';
    }
    return 'high';
  }
}
