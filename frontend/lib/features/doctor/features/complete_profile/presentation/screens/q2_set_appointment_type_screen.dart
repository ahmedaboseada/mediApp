import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/constants/constants.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/q_flow/q_flow_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/widgets/q_progress_widget.dart';

class Q2SetAppointmentTypeScreen extends StatefulWidget {
  const Q2SetAppointmentTypeScreen({super.key});

  @override
  State<Q2SetAppointmentTypeScreen> createState() =>
      _Q2SetAppointmentTypeScreenState();
}

class _Q2SetAppointmentTypeScreenState
    extends State<Q2SetAppointmentTypeScreen> {
  final TextEditingController _maxPatientsController = TextEditingController();
  List<String> _appointmentTypes = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _maxPatientsController.dispose();
    super.dispose();
  }

  List<String> _mapAppointmentTypes(List<String> selectedTypes) {
    return selectedTypes.map((type) {
      switch (type) {
        case 'Clinic Visit':
          return 'in-person';
        case 'Telemedicine':
          return 'online';
        default:
          return type.toLowerCase();
      }
    }).toList();
  }

  Future<void> _submitAppointments() async {
    if (_appointmentTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one appointment type'),
        ),
      );
      return;
    }

    final maxDailyPatients = int.tryParse(_maxPatientsController.text.trim());
    if (maxDailyPatients == null || maxDailyPatients <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid max patients number'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final repo = getIt<DoctorCompleteProfileRepo>();
    final result = await repo.completeAppointments(
      appointmentTypes: _mapAppointmentTypes(_appointmentTypes),
      maxDailyPatients: maxDailyPatients,
    );

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (_) {
        setState(() {
          _isLoading = false;
        });
        context.go(AppRouter.uploadLicenseScreen);
      },
    );
  }

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
                  onSelectionChange: (List<String> selectedTypes) {
                    _appointmentTypes = selectedTypes;
                  },
                  items: DoctorConstants().appointmentsTypes,
                  label: 'What type of appointments do you offer?',
                ),
                SizedBox(height: AppSizes.h16),
                CustomTextField(
                  controller: _maxPatientsController,
                  hintText: 'Max patients per day',
                  keyboardType: TextInputType.number,
                  label: 'Max patients per day',
                ),
                SizedBox(height: AppSizes.h24),
                const QProgressWidget(step: 1),

                SizedBox(height: AppSizes.h12),
                PrimaryButton(
                  text: AppStrings.done,
                  onPressed: _isLoading ? null : _submitAppointments,
                  child: _isLoading
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
                SizedBox(height: AppSizes.h24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
