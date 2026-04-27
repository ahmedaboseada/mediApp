import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/patient_data.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/patients_cubit.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/patients_state.dart';
import 'package:medi/features/doctor/features/patients/presentation/screens/patient_profile_screen.dart';
import 'package:medi/features/doctor/features/patients/presentation/screens/qr_scanner_screen.dart';
import 'package:medi/features/doctor/features/patients/presentation/widgets/patient_card.dart';
import 'package:medi/features/patient/features/add_medication/presentation/widgets/medicine_search_bar.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  static const String _mockPatientToken = 'mock_patient_token_001';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PatientsCubit>()..loadPatients(),
      child: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(),
                      Spacer(),
                      Column(
                        children: [
                          Text(
                            'Patients',
                            style: AppStyles.black24700,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Manage your patient records',
                            style: AppStyles.secondary12400,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () => _onQrTap(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.w8,
                            vertical: AppSizes.h8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          child: Icon(
                            Icons.qr_code_outlined,
                            //color: AppColors.surfaceColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<PatientsCubit, PatientsState>(
                          builder: (context, state) {
                            return MedicineSearchBar(
                              hintText: 'Search by name or ID',
                              enableInput: true,
                              showAction: false,
                              onChanged: (query) {
                                context.read<PatientsCubit>().searchPatients(
                                  query,
                                );
                              },
                              onClear: () {
                                context.read<PatientsCubit>().clearSearch();
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                      onPressed: () {
                        context.push(AppRouter.addPatientScreen);
                      },
                      text: 'Add Patient',
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: BlocBuilder<PatientsCubit, PatientsState>(
                      builder: (context, state) {
                        if (state.status == PatientsStatus.loading) {
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          );
                        }

                        if (state.status == PatientsStatus.failure) {
                          return _ErrorWidget(
                            message:
                                state.errorMessage ?? 'Failed to load patients',
                            onRetry: () {
                              context.read<PatientsCubit>().retry();
                            },
                          );
                        }

                        if (state.status == PatientsStatus.empty ||
                            state.displayedPatients.isEmpty) {
                          return _EmptyWidget(
                            message: state.searchQuery.isNotEmpty
                                ? 'No patients found matching "${state.searchQuery}"'
                                : 'No patients yet',
                          );
                        }

                        return GridView.builder(
                          padding: EdgeInsets.only(bottom: 16.h),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                                childAspectRatio: 0.59,
                              ),
                          itemCount: state.displayedPatients.length,
                          itemBuilder: (context, index) {
                            final patient = state.displayedPatients[index];
                            return PatientCard(
                              patient: patient,
                              onViewProfile: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        PatientProfileScreen(patient: patient),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 65.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onQrTap(BuildContext context) async {
    final scannedToken = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => const QrScannerScreen(mockToken: _mockPatientToken),
      ),
    );

    if (!context.mounted || scannedToken == null || scannedToken.isEmpty) {
      return;
    }

    final patient = _resolvePatientFromToken(context, scannedToken);

    if (patient == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Invalid patient token. Try again.')),
        );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PatientProfileScreen(
          patient: patient,
          showAddMedicationAction: true,
        ),
      ),
    );
  }

  PatientData? _resolvePatientFromToken(BuildContext context, String token) {
    final normalized = token.trim();
    final cubitState = context.read<PatientsCubit>().state;

    final fromLoaded = cubitState.patients.where((patient) {
      return patient.id == normalized ||
          'patient:${patient.id}' == normalized ||
          'patient_token:${patient.id}' == normalized;
    });

    if (fromLoaded.isNotEmpty) {
      return fromLoaded.first;
    }

    if (normalized == _mockPatientToken) {
      return  PatientData(
        id: 'mock-patient-001',
        name: 'Mai Ali',
        age: 25,
        gender: 'female',
        bloodType: 'O+',
        status: PatientStatus.abnormal,
        avatarAsset: AppAssets.avatar1,
        email: 'mai.ali@email.com',
        phone: '+20 100 000 0000',
        allergies: ['Penicillin'],
        chronicConditions: ['Hypertension'],
        medications: [
          MedicationModel(
            name: 'Lisinopril',
            dosage: '10 mg once daily',
            frequency: 'Daily',
             id: '', type: '', stock: 12, isChronic: true, status: '',
          ),
          MedicationModel(
            name: 'Atorvastatin',
            dosage: '20 mg once daily',
            frequency: 'Daily',
              id: '', type: '', stock: 5, isChronic: true, status: '',
          ),
        ],
     
      );
      
    }

    return null;
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF666666)),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E90FF),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 48.sp,
              color: const Color(0xFFCCCCCC),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: const Color(0xFF999999)),
            ),
          ],
        ),
      ),
    );
  }
}
