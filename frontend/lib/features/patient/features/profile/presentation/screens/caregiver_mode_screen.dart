import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/profile/presentation/cubit/caregiver_hub_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/doctor_request_card.dart';

class CaregiverModeScreen extends StatefulWidget {
  const CaregiverModeScreen({super.key});

  @override
  State<CaregiverModeScreen> createState() => _CaregiverModeScreenState();
}

class _CaregiverModeScreenState extends State<CaregiverModeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CaregiverHubCubit>().loadHubData();
    });
  }

  void _enterManagedPatientMode(String patientUserId) {
    getIt<CaregiverModeCubit>().enterCaregiverMode(patientUserId);
    getIt<ManagedPatientDashboardCubit>().loadManagedPatientData();
    context.go('/home');
  }

  void _openCaregiverForm() {
    context.push(
      '${AppRouter.onboardingFlow}${AppRouter.caregiverFormScreen}?fromCaregiverMode=true',
    );
  }

  String _formatRequestedOn(DateTime? date) {
    if (date == null) return 'Requested recently';
    return 'Requested on ${date.month}/${date.day}/${date.year}';
  }

  String _doctorDisplayName(String firstName, String lastName) {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? 'Unknown Doctor' : name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: PrimaryButton(
        onPressed: _openCaregiverForm,
        text: '+ Add Caregiver',
        
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }

            context.go('/profile');
          },
        ),
        title: Text('Caregiver Hub', style: AppStyles.black18500),
        centerTitle: false,
        elevation: 0,
      ),
      body: BlocConsumer<CaregiverHubCubit, CaregiverHubState>(
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          if (state.error != null) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.error!)));
          }

          if (state.message != null) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => context.read<CaregiverHubCubit>().loadHubData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(AppSizes.w16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PrimaryButton(
                    //   onPressed: _openCaregiverForm,
                    //   text: 'Add Caregiver',
                    // ),
                    Text('Pending requests', style: AppStyles.black18500),
                    SizedBox(height: AppSizes.h16),
                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state.requests.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.h20),
                        child: Text(
                          'No pending caregiver requests',
                          style: AppStyles.secondary12400,
                        ),
                      )
                    else
                      ...state.requests.map(
                        (request) => Card(
                          child: Padding(
                            padding: EdgeInsets.all(AppSizes.w16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.patientName,
                                  style: AppStyles.black16400,
                                ),
                                SizedBox(height: AppSizes.h6),
                                Text(
                                  request.patientEmail,
                                  style: AppStyles.secondary12400,
                                ),
                                SizedBox(height: AppSizes.h6),
                                Text(
                                  _formatRequestedOn(request.createdAt),
                                  style: AppStyles.secondary12400,
                                ),
                                SizedBox(height: AppSizes.h12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: state.isActionLoading
                                            ? null
                                            : () => context
                                                  .read<CaregiverHubCubit>()
                                                  .rejectCaregiverRequest(
                                                    requestId: request.id,
                                                  ),
                                        child: const Text('Reject'),
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.w12),
                                    Expanded(
                                      child: FilledButton(
                                        onPressed: state.isActionLoading
                                            ? null
                                            : () => context
                                                  .read<CaregiverHubCubit>()
                                                  .acceptCaregiverRequest(
                                                    requestId: request.id,
                                                  ),
                                        child: const Text('Accept'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: AppSizes.h24),
                    Text('Doctor requests', style: AppStyles.black18500),
                    SizedBox(height: AppSizes.h16),
                    if (state.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (state.doctorRequests.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.h20),
                        child: Text(
                          'No pending doctor requests',
                          style: AppStyles.secondary12400,
                        ),
                      )
                    else
                      ...state.doctorRequests.map(
                        (request) => DoctorRequestCard(
                          name: _doctorDisplayName(
                            request.firstName,
                            request.lastName,
                          ),
                          specialty: request.specialization,
                          clinicName: request.clinicName,
                          profilePicture: request.profilePicture,
                          onAccept: state.isActionLoading
                              ? () {}
                              : () => context
                                    .read<CaregiverHubCubit>()
                                    .acceptDoctorRequest(
                                      doctorId: request.userId,
                                      doctorFcmToken: request.fcmToken,
                                    ),
                          onReject: state.isActionLoading
                              ? () {}
                              : () => context
                                    .read<CaregiverHubCubit>()
                                    .rejectDoctorRequest(
                                      doctorId: request.userId,
                                    ),
                        ),
                      ),
                    SizedBox(height: AppSizes.h24),
                    Text('Managed patients', style: AppStyles.black18500),
                    SizedBox(height: AppSizes.h16),
                    if (state.managedPatients.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSizes.h20),
                        child: Text(
                          'No managed patients yet',
                          style: AppStyles.secondary12400,
                        ),
                      )
                    else
                      ...state.managedPatients.map(
                        (patient) => Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.all(AppSizes.w16),
                            onTap: () =>
                                _enterManagedPatientMode(patient.userId),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.secondary,
                              child: ClipOval(
                                child: SizedBox(
                                  width: AppSizes.w40,
                                  height: AppSizes.w40,
                                  child:
                                      patient.profilePicture.isNotEmpty &&
                                          patient.profilePicture
                                              .toLowerCase()
                                              .startsWith('http')
                                      ? CachedNetworkImage(
                                          imageUrl: patient.profilePicture,
                                          fit: BoxFit.cover,
                                          fadeInDuration: Duration.zero,
                                          placeholder: (_, __) => Center(
                                            child: Text(
                                              patient.name.isNotEmpty
                                                  ? patient.name[0]
                                                        .toUpperCase()
                                                  : 'P',
                                            ),
                                          ),
                                          errorWidget: (_, __, ___) => Center(
                                            child: Text(
                                              patient.name.isNotEmpty
                                                  ? patient.name[0]
                                                        .toUpperCase()
                                                  : 'P',
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            patient.name.isNotEmpty
                                                ? patient.name[0].toUpperCase()
                                                : 'P',
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            title: Text(
                              patient.name,
                              style: AppStyles.black16400,
                            ),
                            subtitle: Text(
                              [
                                if (patient.email.isNotEmpty) patient.email,
                                if (patient.relationship.isNotEmpty)
                                  patient.relationship,
                              ].join(' · '),
                              style: AppStyles.secondary12400,
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded),
                          ),
                        ),
                      ),
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
