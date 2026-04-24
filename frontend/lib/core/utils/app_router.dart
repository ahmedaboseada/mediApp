import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/enums/user_role.dart';
import 'package:medi/core/utils/service_locator.dart';
//import 'package:medi/features/doctor/features/home/presentation/screens/profile_screen.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medication_data_cubit.dart';
import 'package:medi/features/patient/features/add_medication/data/models/medication.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_cubit.dart';
import 'package:medi/features/patient/features/add_medication/presentation/screens/daily_symptoms_screen.dart';
import 'package:medi/features/patient/features/add_medication/presentation/screens/edit_medication_screen.dart';
import 'package:medi/features/patient/features/add_medication/presentation/screens/medicine_info_screen.dart';
import 'package:medi/features/patient/features/doctors/data/models/booking_model.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/my_bookings_cubit.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/screens/add_daily_log_screen.dart';
import 'package:medi/features/patient/features/health_measurements/presentation/screens/health_measurements_screen.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/profile/profile_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/screens/account_info_screen.dart';
import 'package:medi/features/patient/features/profile/presentation/screens/caregiver_mode_screen.dart'
    as profile_caregiver;
import 'package:medi/features/patient/features/profile/presentation/screens/change_email_screen.dart';
import 'package:medi/features/patient/features/profile/presentation/screens/change_password_screen.dart';
import 'package:medi/features/patient/features/add_medication/presentation/screens/choose_method_screen.dart';
import 'package:medi/features/patient/features/add_medication/presentation/screens/medicine_screen.dart';
import 'package:medi/features/patient/features/add_medication/presentation/screens/medication_details_screen.dart';
import 'package:medi/features/patient/features/add_medication/presentation/screens/schedule_reminders_screen.dart';
import 'package:medi/features/patient/features/add_medication/presentation/screens/stock_expiry_screen.dart';
import 'package:medi/features/patient/features/add_medication/presentation/screens/confirmation_screen.dart';
import 'package:medi/features/patient/features/doctors/data/models/doctor_summary.dart';
import 'package:medi/features/patient/features/doctors/data/models/appointment_review_data.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/review_summary_screen.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/payment_success_screen.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/my_appointment_screen.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/patient_details_screen.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/add_card_screen.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/payment_method_screen.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/select_package_screen.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/booking_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/browse_doctors_screen.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/doctor_profile_screen.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/my_bookings_screen.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/cancel_booking_screen.dart';
import 'package:medi/features/patient/features/doctors/presentation/screens/search_doctors_screen.dart';
import 'package:medi/features/patient/features/profile/presentation/screens/profile_screen.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/screens/take_info_screen.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/shared/auth/presentation/cubit/complete_profile/complete_profile_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/forget_password/forget_password_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/log_out/log_out_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/otp/otp_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/register/register_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/signin/sigin_cubit.dart';
import 'package:medi/features/shared/auth/presentation/cubit/user_profile/user_profile_cubit.dart';
import 'package:medi/features/shared/auth/presentation/screens/complete_your_profile.dart';
import 'package:medi/features/shared/auth/presentation/screens/forget_password_screen.dart';
import 'package:medi/features/shared/auth/presentation/screens/otp_screen.dart';
import 'package:medi/features/shared/auth/presentation/screens/password_changed_screen.dart';
import 'package:medi/features/shared/auth/presentation/screens/profile_completed.dart';
import 'package:medi/features/shared/auth/presentation/screens/set_password_screen.dart';
import 'package:medi/features/shared/auth/presentation/screens/sign_up_screen.dart';
import 'package:medi/features/shared/auth/presentation/screens/sing_in_screen.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/cubit/doctor_complete_profile_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/q_flow/q_flow_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/allow_location_screen.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/allow_notification_screen.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/doctor_all_set_screen.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/doctor_complete_profile.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/enter_location_manually.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/upload_license_screen.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/widgets/q_flow.dart';
import 'package:medi/features/doctor/features/home/presentation/screens/main_layout.dart';
import 'package:medi/features/doctor/features/patients/presentation/screens/add_patient_screen.dart';
import 'package:medi/features/doctor/features/settings/presentation/controller/cubit/schedule_cubit.dart';
import 'package:medi/features/doctor/features/settings/presentation/screens/account_information_screen.dart';
import 'package:medi/features/doctor/features/settings/presentation/screens/payout_withdrawal_screen.dart';
import 'package:medi/features/doctor/features/settings/presentation/screens/schedule_availability_screen.dart';
import 'package:medi/features/patient/features/home/presentation/screens/home_screen.dart';
import 'package:medi/features/patient/features/home/presentation/screens/main_patient_view.dart';
import 'package:medi/features/patient/features/notification_sound/presentation/controller/sound_cubit/sound_cubit.dart';
import 'package:medi/features/patient/features/notification_sound/presentation/screens/choose_sound_screen.dart';
import 'package:medi/features/patient/features/notification_sound/presentation/screens/notification_sound_screen.dart';
import 'package:medi/features/patient/features/questionnaire/data/repo/questionnaire_repo.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/cubit/cubit/questinnaire_cubit.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/screens/all_set_screen.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/screens/caregiver_form_screen.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/screens/invitation_send_screen.dart';
import 'package:medi/features/patient/features/questionnaire/presentation/screens/q3_caregiver_mode_screen.dart';
import 'package:medi/features/patient/features/questionnaire/questionnaire_flow.dart';
import 'package:medi/features/shared/splash/presentation/screens/select_screen.dart';
import 'package:medi/features/shared/splash/presentation/screens/onboarding_screen.dart';
import 'package:medi/features/shared/splash/presentation/screens/splash_screen.dart';
import 'package:medi/main.dart';

class AppRouter {
  // ========== SHARED ROUTES ==========
  static const String splashScreen = '/';
  static const String welcomeScreen = '/welcome';
  static const String selectScreen = '/selectRole';
  static const String onboardingScreen = '/onboarding';

  // ========== SHARED AUTH ROUTES ==========
  static const String setPasswordScreen = '/setPassword';
  static const String otpScreen = '/otp';
  static const String forgetPasswordScreen = '/forgetPassword';
  static const String passwordChangedScreen = '/passwordChanged';

  // ========== PATIENT ROUTES ==========
  static const String patientLogin = '/login/patient';
  static const String signUpScreen = '/signUp/patient';
  // static const String homeScreen = '/home';
  static const String patientMainView = '/patient/main';
  static const String completeProfile = '/completeProfile';
  static const String onboardingFlow = '/onboardingFlow';
  static const String caregiverFormScreen = '/caregiverForm';
  static const String invitationSendScreen = '/invitationSend';
  static const String patientProfileCompletedScreen =
      '/patient/ProfileCompleted';
  static const String notificationSoundScreen = '/notificationSound';
  static const String chooseSoundScreen = '/chooseSound';
  static const String takeInfoScreen = '/takeInfo';
  static const String caregiverModeScreen = '/CaregiverModeScreen';
  static const String allSetScreen = '/AllSetScreen';
  static const String patientAccountInfoScreen = '/patient/accountInfo';
  static const String patientCaregiverModeScreen = '/patient/caregiverMode';
  static const String changeEmailScreen = '/patient/changeEmail';
  static const String changePasswordScreen = '/patient/changePassword';
  static const String chooseMethodScreen =
      '/patient/addMedication/chooseMethod';
  static const String addMedicationFlow = '/patient/addMedication';
  static const String medicationDetailsScreen =
      '/patient/addMedication/details';
  static const String scheduleRemindersScreen =
      '/patient/addMedication/schedule';
  static const String stockExpiryScreen = '/patient/addMedication/stock';
  static const String confirmationScreen =
      '/patient/addMedication/confirmation';
  static const String dailySymptomsScreen = '/medicine/dailySymptoms';
  static const String editMedicationScreen = '/patient/editMedication';
  static const String medicineInfoScreen = '/patient/medicineInfo';
  static const String doctorProfileScreen = '/doctors/profile';
  static const String doctorBookAppointmentScreen = '/doctors/profile/book';
  static const String patientDetailsScreen =
      '/doctors/profile/book/patient-details';
  static const String patientPaymentMethodScreen =
      '/doctors/profile/book/patient-details/payment-method';
  static const String patientAddCardScreen =
      '/doctors/profile/book/patient-details/payment-method/add-card';
  static const String patientReviewSummaryScreen =
      '/doctors/profile/book/patient-details/payment-method/review-summary';
  static const String patientPaymentSuccessScreen =
      '/doctors/profile/book/patient-details/payment-method/review-summary/success';
  static const String patientMyAppointmentScreen =
      '/doctors/profile/book/patient-details/payment-method/review-summary/success/my-appointment';
  static const String patientCancelBookingScreen = '/doctors/cancel-booking';
  // ========== DOCTOR ROUTES ==========
  static const String doctorLogin = '/login/doctor';
  static const String doctorSignUpScreen = '/signUp/doctor';
  static const String doctorOtpScreen = '/doctorOtp';
  static const String doctorCompleteProfile = '/doctor/completeProfile';
  static const String allowLocationScreen = '/doctor/allowLocation';
  static const String mainLayout = '/doctor/mainLayout';
  static const String availabilityScreen = '/doctor/availability';
  static const String accountInformationScreen = '/doctor/accountInformation';
  static const String payoutWithdrawalScreen = '/doctor/payoutWithdrawal';
  static const String manualLocationScreen = '/doctor/manualLocation';
  static const String doctorProfileCompletedScreen = '/doctor/ProfileCompleted';
  static const String qFlowScreen = '/doctor/qFlow';
  static const String uploadLicenseScreen = '/doctor/uploadLicense';
  static const String allowNotificationScreen = '/doctor/allowNotification';
  static const String doctorAllSetScreen = '/doctorAllSetScreen';
  static const String addPatientScreen = '/doctor/addPatient';
  static const String healthMeasurements = '/healthMeasurements';
  static const String dailyHealthLogScreen = '/health/dailyLog';

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    routes: [
      // ========== SHARED/SPLASH ROUTES ==========
      GoRoute(
        path: splashScreen,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: selectScreen,
        builder: (context, state) {
          return const SelectScreen();
        },
      ),
      GoRoute(
        path: onboardingScreen,
        builder: (context, state) {
          return const OnboardingScreen();
        },
      ),

      // ========== PATIENT ROUTES ==========
      GoRoute(
        path: patientLogin,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => SiginCubit(getIt<AuthRepoImpl>()),
            child: SignInScreen(role: UserRole.patient),
          );
        },
      ),
      GoRoute(
        path: signUpScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => RegisterCubit(getIt<AuthRepoImpl>()),
            child: SignUpScreen(role: UserRole.patient),
          );
        },
      ),
      GoRoute(
        path: completeProfile,
        builder: (context, state) => BlocProvider(
          create: (context) => CompleteProfileCubit(getIt<AuthRepoImpl>()),
          child: const CompleteYourProfileScreen(),
        ),
      ),
      GoRoute(
        path: chooseSoundScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<SoundCubit>()..loadSounds(),
            child: const ChooseSoundScreen(),
          );
        },
      ),

      GoRoute(
        path: notificationSoundScreen,
        builder: (context, state) {
          final cubit = state.extra as SoundCubit;

          return BlocProvider.value(
            value: cubit,
            child: const NotificationSoundScreen(),
          );
        },
      ),
      GoRoute(
        path: takeInfoScreen,
        builder: (context, state) {
          return const TakeInfoScreen();
        },
      ),

      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) => QuestionnaireCubit(getIt<QuestionnaireRepo>()),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: onboardingFlow,
            builder: (context, state) => const OnboardingFlow(),
          ),
          GoRoute(
            path: '$onboardingFlow/caregiverMode',
            builder: (context, state) => const CaregiverModeScreen(),
          ),
          GoRoute(
            path: '$onboardingFlow/caregiverForm',
            builder: (context, state) => const CaregiverFormScreen(),
          ),
          GoRoute(
            path: '$onboardingFlow/invitationSend',
            builder: (context, state) => InvitationSendScreen(),
          ),
          GoRoute(
            path: '$onboardingFlow/allSet',
            builder: (context, state) => const AllSetScreen(),
          ),
        ],
      ),

      GoRoute(
        path: manualLocationScreen,
        builder: (context, state) => const ManualLocationScreen(),
      ),
      GoRoute(
        path: patientAccountInfoScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => UserProfileCubit(getIt<AuthRepoImpl>()),
          child: AccountInfoScreen(),
        ),
      ),
      GoRoute(
        path: patientCaregiverModeScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ProfileCubit>(),
          child: const profile_caregiver.CaregiverModeScreen(),
        ),
      ),
      GoRoute(
        path: changeEmailScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ProfileCubit>(),
          child: const ChangeEmailScreen(),
        ),
      ),
      GoRoute(
        path: changePasswordScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ProfileCubit>(),
          child: ChangePasswordScreen(),
        ),
      ),
      GoRoute(
        path: healthMeasurements,
        builder: (context, state) => HealthMeasurementsScreen(),
      ),
      GoRoute(
        path: dailyHealthLogScreen,
        builder: (context, state) => const DailyHealthLogScreen(),
      ),
      GoRoute(
        path: editMedicationScreen,
        builder: (context, state) =>
            EditMedicationScreen(medication: state.extra as Medication?),
      ),
      GoRoute(
        path: medicineInfoScreen,
        builder: (context, state) {
          final medication = state.extra as Medication?;
          return MedicineInfoScreen(medication: medication);
        },
      ),

      /// ================= PATIENT SHELL =================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainPatientView(shell: navigationShell);
        },
        branches: [
          /// ========= HOME TAB =========
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
            ],
          ),

          /// ========= MEDICINE TAB =========
          StatefulShellBranch(
            routes: [
              ShellRoute(
                builder: (context, state, child) {
                  return BlocProvider(
                    create: (_) => MedicationDataCubit(),
                    child: BlocProvider(
                      create: (_) => getIt<MedicineCubit>()..loadMedications(),
                      child: child,
                    ),
                  );
                },
                routes: [
                  GoRoute(
                    path: '/medicine',
                    builder: (context, state) => const MedicineScreen(),
                  ),
                  GoRoute(
                    path: '/medicine/chooseMethod',
                    builder: (context, state) => const ChooseMethodScreen(),
                  ),
                  GoRoute(
                    path: '/medicine/details',
                    builder: (context, state) =>
                        const MedicationDetailsScreen(),
                  ),
                  GoRoute(
                    path: '/medicine/schedule',
                    builder: (context, state) =>
                        const ScheduleRemindersScreen(),
                  ),
                  GoRoute(
                    path: '/medicine/stock',
                    builder: (context, state) => const StockExpiryScreen(),
                  ),
                  GoRoute(
                    path: '/medicine/confirmation',
                    builder: (context, state) => const ConfirmationScreen(),
                  ),
                  GoRoute(
                    path: '/medicine/info',
                    builder: (context, state) {
                      final medication = state.extra as Medication?;
                      return MedicineInfoScreen(medication: medication);
                    },
                  ),
                  GoRoute(
                    path: editMedicationScreen,
                    builder: (context, state) => EditMedicationScreen(
                      medication: state.extra as Medication?,
                    ),
                  ),
                  GoRoute(
                    path: dailySymptomsScreen,
                    builder: (context, state) => const DailySymptomsScreen(),
                  ),
                ],
              ),
            ],
          ),

          /// ========= DOCTORS TAB =========
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/doctors',
                builder: (context, state) => const BrowseDoctorsScreen(),
                routes: [
                  GoRoute(
                    path: 'my-bookings',
                    builder: (context, state) => const MyBookingsScreen(),
                  ),
                  GoRoute(
                    path: 'cancel-booking',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      return BlocProvider.value(
                        value: extra['cubit'] as MyBookingsCubit,
                        child: CancelBookingScreen(
                          booking: extra['booking'] as BookingModel,
                          cubit: extra['cubit'] as MyBookingsCubit,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'browse',
                    builder: (context, state) => const BrowseDoctorsScreen(),
                  ),
                  GoRoute(
                    path: 'search',
                    builder: (context, state) => const SearchDoctorsScreen(),
                  ),
                  ShellRoute(
                    builder: (context, state, child) => BlocProvider(
                      create: (context) => BookingCubit(
                        doctorsRepository: getIt<DoctorsRepository>(),
                      ),
                      child: child,
                    ),
                    routes: [
                      GoRoute(
                        path: 'profile',
                        builder: (context, state) => DoctorProfileScreen(
                          doctor: state.extra as DoctorModel,
                        ),
                        routes: [
                          GoRoute(
                            path: 'book',
                            builder: (context, state) => SelectPackageScreen(
                              doctor: state.extra as DoctorModel,
                            ),
                            routes: [
                              GoRoute(
                                path: 'patient-details',
                                builder: (context, state) =>
                                    PatientDetailsScreen(
                                      initialData:
                                          state.extra as AppointmentReviewData?,
                                    ),
                                routes: [
                                  GoRoute(
                                    path: 'payment-method',
                                    builder: (context, state) =>
                                        PaymentMethodScreen(
                                          initialData:
                                              state.extra
                                                  as AppointmentReviewData?,
                                        ),
                                    routes: [
                                      GoRoute(
                                        path: 'add-card',
                                        builder: (context, state) =>
                                            AddCardScreen(
                                              initialData:
                                                  state.extra
                                                      as AppointmentReviewData?,
                                            ),
                                      ),
                                      GoRoute(
                                        path: 'review-summary',
                                        builder: (context, state) =>
                                            ReviewSummaryScreen(
                                              reviewData:
                                                  state.extra
                                                      as AppointmentReviewData?,
                                            ),
                                        routes: [
                                          GoRoute(
                                            path: 'success',
                                            builder: (context, state) =>
                                                PaymentSuccessScreen(
                                                  reviewData:
                                                      state.extra
                                                          as AppointmentReviewData?,
                                                ),
                                            routes: [
                                              GoRoute(
                                                path: 'my-appointment',
                                                builder: (context, state) =>
                                                    MyAppointmentScreen(
                                                      reviewData:
                                                          state.extra
                                                              as AppointmentReviewData?,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          /// ========= CHAT TAB =========
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                builder: (context, state) => Container(color: Colors.yellow),
              ),
            ],
          ),

          /// ========= PROFILE TAB =========
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (_) => getIt<ProfileCubit>()),
                    BlocProvider(
                      create: (_) => LogOutCubit(getIt<AuthRepoImpl>()),
                    ),
                  ],
                  child: const ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
      // ========== DOCTOR ROUTES ==========
      GoRoute(
        path: doctorLogin,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => SiginCubit(getIt<AuthRepoImpl>()),
            child: SignInScreen(role: UserRole.doctor),
          );
        },
      ),
      GoRoute(
        path: doctorSignUpScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => RegisterCubit(getIt<AuthRepoImpl>()),
            child: SignUpScreen(role: UserRole.doctor),
          );
        },
      ),
      GoRoute(
        path: doctorCompleteProfile,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              DoctorCompleteProfileCubit(getIt<DoctorCompleteProfileRepo>()),
          child: DoctorCompleteProfile(),
        ),
      ),

      GoRoute(
        path: allowLocationScreen,
        builder: (context, state) => const AllowLocationScreen(),
      ),
      GoRoute(
        path: mainLayout,
        builder: (context, state) => const MainDoctorView(),
      ),
      GoRoute(
        path: availabilityScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => ScheduleCubit(),
          child: const ScheduleAvailabilityScreen(),
        ),
      ),
      GoRoute(
        path: accountInformationScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => UserProfileCubit(getIt<AuthRepoImpl>())..getMe(),
          child: AccountInformationScreen(),
        ),
      ),
      GoRoute(
        path: payoutWithdrawalScreen,
        builder: (context, state) => PayoutWithdrawalScreen(),
      ),
      GoRoute(
        path: qFlowScreen,
        builder: (context, state) =>
            BlocProvider(create: (context) => QFlowCubit(), child: QFlow()),
      ),
      GoRoute(
        path: uploadLicenseScreen,
        builder: (context, state) => const UploadLicenseScreen(),
      ),
      GoRoute(
        path: allowNotificationScreen,
        builder: (context, state) => AllowNotificationScreen(),
      ),
      GoRoute(
        path: addPatientScreen,
        builder: (context, state) => const AddPatientScreen(),
      ),
      GoRoute(
        path: doctorAllSetScreen,
        builder: (context, state) => const DoctorAllSetScreen(),
      ),

      // ========== SHARED AUTH ROUTES ==========
      GoRoute(
        path: otpScreen,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => OtpCubit(getIt<AuthRepoImpl>()),
            child: OtpScreen(
              email: data['email'] as String,
              role: data['role'] as UserRole,
              is2FA: (data['is2FA'] as bool?) ?? false,
            ),
          );
        },
      ),
      GoRoute(
        path: setPasswordScreen,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => ResetPasswordCubit(getIt<AuthRepoImpl>()),
            child: SetPasswordScreen(
              resetToken: data['resetToken'] as String,
              role: data['role'] as UserRole,
            ),
          );
        },
      ),
      GoRoute(
        path: passwordChangedScreen,
        builder: (context, state) {
          return PasswordChangedScreen(role: state.extra as UserRole);
        },
      ),
      GoRoute(
        path: patientProfileCompletedScreen,
        builder: (context, state) {
          return const ProfileCompleted(user: UserRole.patient);
        },
      ),
      GoRoute(
        path: doctorProfileCompletedScreen,
        builder: (context, state) {
          return const ProfileCompleted(user: UserRole.doctor);
        },
      ),
      GoRoute(
        path: forgetPasswordScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => ForgetPasswordCubit(getIt<AuthRepoImpl>()),
            child: ForgetPasswordScreen(role: state.extra as UserRole),
          );
        },
      ),
    ],
  );
}
