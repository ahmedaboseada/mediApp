// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:medi/core/core.dart';
// import '../../data/models/patient_data.dart';
// import '../cubit/booking_session_enhanced_cubit.dart';
// import '../cubit/booking_session_state_enhanced.dart';
// import '../widgets/patient_health_reports_tab.dart';
// import '../widgets/patient_medications_tab.dart';
// import '../widgets/patient_overview_tab.dart';

// /// Manages tab navigation for patient profile content.
// /// Renders different tabs based on selected index.
// class _PatientTabsSection extends StatefulWidget {
//   const _PatientTabsSection({
//     required this.patient,
//     required this.showAddMedicationAction,
//     required this.onAddMedication,
//   });

//   final PatientData patient;
//   final bool showAddMedicationAction;
//   final VoidCallback onAddMedication;

//   @override
//   State<_PatientTabsSection> createState() => _PatientTabsSectionState();
// }

// class _PatientTabsSectionState extends State<_PatientTabsSection> {
//   int _selectedTabIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Tab content renders based on selected index
//         if (_selectedTabIndex == 0) ...[
//           PatientOverviewTab(patient: widget.patient),
//         ] else if (_selectedTabIndex == 1) ...[
//           PatientMedicationsTab(
//             patient: widget.patient,
//             showAddMedicationAction: widget.showAddMedicationAction,
//             onAddMedication: widget.onAddMedication,
//           ),
//         ] else if (_selectedTabIndex == 2) ...[
//           PatientHealthReportsTab(patient: widget.patient),
//         ],
//       ],
//     );
//   }
// }

// /// Displays active session information with countdown timer and end-session button.
// /// Listens to BookingSessionEnhancedCubit for timer updates and session state.
// class _SessionPanel extends StatelessWidget {
//   const _SessionPanel({required this.onAddMedicationPressed});

//   final VoidCallback onAddMedicationPressed;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BookingSessionEnhancedCubit, BookingSessionState>(
//       buildWhen: (previous, current) =>
//           previous.session != current.session ||
//           previous.remainingTime != current.remainingTime ||
//           previous.status != current.status,
//       builder: (context, state) {
//         final session = state.session;
//         if (session == null) {
//           return const SizedBox.shrink();
//         }

//         final isExpired = state.isSessionExpired;
//         final isEnding = state.isEndingSession;
//         final timeRemaining = BookingSessionEnhancedCubit.formatDuration(
//           state.remainingTime,
//         );

//         return Container(
//           width: double.infinity,
//           padding: EdgeInsets.all(AppSizes.w16),
//           decoration: BoxDecoration(
//             color: AppColors.surfaceColor,
//             borderRadius: BorderRadius.circular(20.r),
//             border: Border.all(color: AppColors.primary.withOpacity(0.12)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header: Title and status badge
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'Active session',
//                       style: AppStyles.black18500,
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: AppSizes.w10,
//                       vertical: AppSizes.h6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isExpired
//                           ? const Color(0xFFFFE8E8)
//                           : const Color(0xFFE8F6FF),
//                       borderRadius: BorderRadius.circular(999.r),
//                     ),
//                     child: Text(
//                       isExpired ? 'Expired' : 'Live',
//                       style: TextStyle(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w600,
//                         color: isExpired
//                             ? const Color(0xFFD32F2F)
//                             : const Color(0xFF0B6FA4),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: AppSizes.h10),

//               // Session ID
//               Text(
//                 'Booking ID: ${session.bookingId}',
//                 style: AppStyles.secondary12400,
//               ),
//               SizedBox(height: AppSizes.h6),

//               // Timer display
//               Text(
//                 isExpired
//                     ? 'Session timer expired'
//                     : 'Time remaining: $timeRemaining',
//                 style: AppStyles.black14500,
//               ),
//               SizedBox(height: AppSizes.h12),

//               // End session button
//               SizedBox(
//                 width: double.infinity,
//                 child: FilledButton.icon(
//                   onPressed: (isExpired || isEnding)
//                       ? null
//                       : () {
//                           context
//                               .read<BookingSessionEnhancedCubit>()
//                               .endCurrentSession();
//                         },
//                   icon: isEnding
//                       ? SizedBox(
//                           height: 16.sp,
//                           width: 16.sp,
//                           child: const CircularProgressIndicator(
//                             strokeWidth: 2,
//                           ),
//                         )
//                       : const Icon(Icons.stop_circle_outlined),
//                   label: Text(
//                     isEnding ? 'Ending session...' : 'End session',
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
