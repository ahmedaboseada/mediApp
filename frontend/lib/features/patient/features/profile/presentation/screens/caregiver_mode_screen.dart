import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/patient/features/profile/data/models/caregiver_request_model.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/profile/profile_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/caregiving_request_card.dart';
import 'package:medi/features/patient/features/profile/presentation/widgets/caretaker_card.dart';

class CaregiverModeScreen extends StatefulWidget {
  const CaregiverModeScreen({super.key});

  @override
  State<CaregiverModeScreen> createState() => _CaregiverModeScreenState();
}

class _CaregiverModeScreenState extends State<CaregiverModeScreen> {
  List<CaregiverRequestModel> caregivingRequests = [];

  final List<Map<String, String>> caretakers = [
    {
      'name': 'Dr. James Wilson',
      'email': 'j.wilson@healthcare.com',
      'since': 'Since 12/15/2023',
      'initials': 'D',
    },
    {
      'name': 'Maria Garcia',
      'email': 'maria.g@email.com',
      'since': 'Since 1/20/2024',
      'initials': 'M',
    },
  ];

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().listCaregiverRequests();
  }

  String _formatRequestedOn(DateTime? date) {
    if (date == null) return 'Requested recently';
    return 'Requested on ${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Caregiver Mode', style: AppStyles.black18500),
        centerTitle: false,
        elevation: 0,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is CaregiverRequestsSuccess) {
            setState(() {
              caregivingRequests = state.requests;
            });
          }

          if (state is CaregiverRequestActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is CaregiverRequestsFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state is CaregiverRequestActionFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isActionLoading = state is CaregiverRequestActionLoading;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.w16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Caregiving Requests', style: AppStyles.black18500),
                  SizedBox(height: AppSizes.h16),
                  if (state is CaregiverRequestsLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (caregivingRequests.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSizes.h32),
                      child: Center(
                        child: Text(
                          'No pending caregiver requests',
                          style: AppStyles.secondary12400,
                        ),
                      ),
                    )
                  else
                    ...caregivingRequests.map((request) {
                      return CaregivingRequestCard(
                        name: request.patientName,
                        email: request.patientEmail,
                        requestedOn: _formatRequestedOn(request.createdAt),
                        onAccept: isActionLoading
                            ? () {}
                            : () {
                                context
                                    .read<ProfileCubit>()
                                    .acceptCaregiverRequest(
                                      requestId: request.id,
                                    );
                              },
                        onReject: isActionLoading
                            ? () {}
                            : () {
                                context
                                    .read<ProfileCubit>()
                                    .rejectCaregiverRequest(
                                      requestId: request.id,
                                    );
                              },
                      );
                    }),
                  SizedBox(height: AppSizes.h32),
                  Text('My Caretakers', style: AppStyles.black18500),
                  SizedBox(height: AppSizes.h16),
                  if (caretakers.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSizes.h32),
                      child: Center(
                        child: Text(
                          'No caretakers added',
                          style: AppStyles.secondary12400,
                        ),
                      ),
                    )
                  else
                    ...caretakers.map((caretaker) {
                      return CaretakerCard(
                        name: caretaker['name'] ?? '',
                        email: caretaker['email'] ?? '',
                        since: caretaker['since'] ?? '',
                        initials: caretaker['initials'] ?? '',
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
