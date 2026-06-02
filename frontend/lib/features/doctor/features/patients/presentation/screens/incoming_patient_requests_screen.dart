import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi/core/core.dart';
import 'package:medi/features/doctor/features/patients/data/models/incoming_patient_request_model.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/incoming_patient_requests/incoming_patient_requests_cubit.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/incoming_patient_requests/incoming_patient_requests_state.dart';

class IncomingPatientRequestsScreen extends StatelessWidget {
  const IncomingPatientRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          IncomingPatientRequestsCubit(getIt<ApiService>())..loadRequests(),
      child: const _IncomingPatientRequestsView(),
    );
  }
}

class _IncomingPatientRequestsView extends StatelessWidget {
  const _IncomingPatientRequestsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(AppSizes.r40),
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: AppSizes.w40,
                      height: AppSizes.w40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(AppSizes.r40),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Incoming Requests',
                        style: AppStyles.black18500,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSizes.w40),
                ],
              ),
              SizedBox(height: AppSizes.h20),
              Expanded(
                child:
                    BlocConsumer<
                      IncomingPatientRequestsCubit,
                      IncomingPatientRequestsState
                    >(
                      listener: (context, state) {
                        if (state.status ==
                                IncomingPatientRequestsStatus.failure &&
                            state.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.errorMessage!)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state.status ==
                                IncomingPatientRequestsStatus.loading &&
                            state.requests.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.status ==
                                IncomingPatientRequestsStatus.failure &&
                            state.requests.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.errorMessage ??
                                      'Failed to load requests',
                                  style: AppStyles.secondary12400,
                                ),
                                SizedBox(height: AppSizes.h12),
                                PrimaryButton(
                                  onPressed: () => context
                                      .read<IncomingPatientRequestsCubit>()
                                      .loadRequests(),
                                  text: 'Retry',
                                ),
                              ],
                            ),
                          );
                        }

                        final requests = state.requests;
                        if (requests.isEmpty) {
                          return const _EmptyRequestsState();
                        }

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: requests.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: AppSizes.h12),
                          itemBuilder: (context, index) {
                            final request = requests[index];
                            final isProcessing =
                                state.processingRequestId ==
                                request.patientObjectId;
                            return _RequestCard(
                              request: request,
                              isProcessing: isProcessing,
                              onAccept: () async {
                                await context
                                    .read<IncomingPatientRequestsCubit>()
                                    .acceptRequest(request);
                              },
                              onReject: () async {
                                await context
                                    .read<IncomingPatientRequestsCubit>()
                                    .rejectRequest(request);
                              },
                            );
                          },
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.isProcessing,
    required this.onAccept,
    required this.onReject,
  });

  final IncomingPatientRequestModel request;
  final bool isProcessing;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surfaceColor,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: AppSizes.r24,
                  backgroundColor: const Color(0xFFEAF2FF),
                  backgroundImage: request.avatarUrl.isNotEmpty
                      ? NetworkImage(request.avatarUrl)
                      : null,
                  child: request.avatarUrl.isEmpty
                      ? Icon(
                          Icons.person_outline,
                          color: AppColors.primary,
                          size: AppSizes.sp22,
                        )
                      : null,
                ),
                SizedBox(width: AppSizes.w12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(request.name, style: AppStyles.black14500),
                      SizedBox(height: AppSizes.h4),
                      Text(
                        request.message?.isNotEmpty == true
                            ? request.message!
                            : 'Wants to connect and access patient services.',
                        style: AppStyles.secondary12400,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isProcessing ? null : onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFD32F2F),
                      side: const BorderSide(color: Color(0xFFFFB3B3)),
                      padding: EdgeInsets.symmetric(vertical: AppSizes.h12),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                SizedBox(width: AppSizes.w12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isProcessing ? null : onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.whiteText,
                      padding: EdgeInsets.symmetric(vertical: AppSizes.h12),
                      elevation: 0,
                    ),
                    child: isProcessing
                        ? SizedBox(
                            height: AppSizes.h18,
                            width: AppSizes.h18,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyRequestsState extends StatelessWidget {
  const _EmptyRequestsState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline,
            size: AppSizes.sp48,
            color: AppColors.tertiaryText,
          ),
          SizedBox(height: AppSizes.h12),
          Text('No incoming patient requests', style: AppStyles.black18500),
          SizedBox(height: AppSizes.h8),
          Text(
            'New patient requests will appear here.',
            style: AppStyles.secondary12400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
