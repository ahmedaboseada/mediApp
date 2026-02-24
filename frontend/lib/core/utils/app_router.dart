import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/enums/user_role.dart';
import 'package:medi/core/utils/service_locator.dart';
import 'package:medi/features/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/auth/presentation/cubit/complete_profile/complete_profile_cubit.dart';
import 'package:medi/features/auth/presentation/cubit/forget_password/forget_password_cubit.dart';
import 'package:medi/features/auth/presentation/cubit/log_out/log_out_cubit.dart';
import 'package:medi/features/auth/presentation/cubit/otp/otp_cubit.dart';
import 'package:medi/features/auth/presentation/cubit/register/register_cubit.dart';
import 'package:medi/features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import 'package:medi/features/auth/presentation/cubit/signin/sigin_cubit.dart';
import 'package:medi/features/auth/presentation/screens/complete_your_profile.dart';
import 'package:medi/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:medi/features/auth/presentation/screens/otp_screen.dart';
import 'package:medi/features/auth/presentation/screens/password_changed_screen.dart';
import 'package:medi/features/auth/presentation/screens/profile_completed.dart';
import 'package:medi/features/auth/presentation/screens/set_password_screen.dart';
import 'package:medi/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:medi/features/auth/presentation/screens/sing_in_screen.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/controller/q_flow/q_flow_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/allow_location_screen.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/allow_notification_screen.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/doctor_all_set_screen.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/doctor_complete_profile.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/enter_location_manually.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/widgets/q_flow.dart';
import 'package:medi/features/doctor/features/home/presentation/screens/main_layout.dart';
import 'package:medi/features/doctor/features/settings/presentation/controller/cubit/schedule_cubit.dart';
import 'package:medi/features/doctor/features/settings/presentation/screens/account_information_screen.dart';
import 'package:medi/features/doctor/features/settings/presentation/screens/payout_withdrawal_screen.dart';
import 'package:medi/features/doctor/features/settings/presentation/screens/schedule_availability_screen.dart';
import 'package:medi/features/patient/home/presentation/screens/home_screen.dart';
import 'package:medi/features/patient/notification_sound/presentation/controller/sound_cubit/sound_cubit.dart';
import 'package:medi/features/patient/notification_sound/presentation/screens/choose_sound_screen.dart';
import 'package:medi/features/patient/notification_sound/presentation/screens/notification_sound_screen.dart';
import 'package:medi/features/patient/questionnaire/presentation/cubit/cubit/questinnaire_cubit.dart';
import 'package:medi/features/patient/questionnaire/presentation/screens/all_set_screen.dart';
import 'package:medi/features/patient/questionnaire/presentation/screens/caregiver_form_screen.dart';
import 'package:medi/features/patient/questionnaire/presentation/screens/invitation_send_screen.dart';
import 'package:medi/features/patient/questionnaire/presentation/screens/q3_caregiver_mode_screen.dart';
import 'package:medi/features/patient/questionnaire/questionnaire_flow.dart';
import 'package:medi/features/patient/questionnaire/presentation/screens/take_info_screen.dart';
import 'package:medi/features/splash/presentation/screens/select_screen.dart';
import 'package:medi/features/splash/presentation/screens/onboarding_screen.dart';
import 'package:medi/features/splash/presentation/screens/splash_screen.dart';

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
  static const String homeScreen = '/home';
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
  static const String allowNotificationScreen = '/doctor/allowNotification';
  static const String doctorAllSetScreen = '/doctorAllSetScreen';

  static final router = GoRouter(
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
        builder: (context, state) {
          return BlocProvider(
            create: (context) => ProfileFormCubit(),
            child: CompleteYourProfileScreen(),
          );
        },
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
        path: takeInfoScreen,
        builder: (context, state) {
          return const TakeInfoScreen();
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
        path: homeScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => LogOutCubit(getIt<AuthRepoImpl>()),
            child: HomeScreen(),
          );
        },
      ),
      GoRoute(
        path: onboardingFlow,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => QuestionnaireCubit(),
            child: const OnboardingFlow(),
          );
        },
        routes: [
          GoRoute(
            path: 'caregiverMode',
            builder: (context, state) => const CaregiverModeScreen(),
          ),
          GoRoute(
            path: 'caregiverForm',
            builder: (context, state) => CaregiverFormScreen(),
          ),
          GoRoute(
            path: 'invitationSend',
            builder: (context, state) => InvitationSendScreen(),
          ),
          GoRoute(
            path: 'allSet',
            builder: (context, state) => const AllSetScreen(),
          ),
        ],
      ),
      // GoRoute(
      //   path: caregiverFormScreen,
      //   builder: (context, state) {
      //     return CaregiverFormScreen();
      //   },
      // ),
      // GoRoute(
      //   path: invitationSendScreen,
      //   builder: (context, state) {
      //     return InvitationSendScreen();
      //   },
      // ),
      GoRoute(
        path: manualLocationScreen,
        builder: (context, state) => const ManualLocationScreen(),
      ),
      // GoRoute(
      //   path: caregiverModeScreen,
      //   builder: (context, state) => const CaregiverModeScreen(),
      // ),
      // GoRoute(path: allSetScreen,
      // builder: (context, state) => const AllSetScreen(),
      // ),

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
        builder: (context, state) {
          return BlocProvider(
            create: (context) => ProfileFormCubit(),
            child: DoctorCompleteProfile(),
          );
        },
      ),

      GoRoute(
        path: allowLocationScreen,
        builder: (context, state) => const AllowLocationScreen(),
      ),
      GoRoute(
        path: mainLayout,
        builder: (context, state) => const MainLayout(),
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
        builder: (context, state) => AccountInformationScreen(),
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
        path: allowNotificationScreen,
        builder: (context, state) => AllowNotificationScreen(),
      ),
      GoRoute(
        path: doctorAllSetScreen,
        builder: (context, state) => const DoctorAllSetScreen(),
      ),

      // ========== SHARED AUTH ROUTES ==========
      GoRoute(
        path: otpScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => OtpCubit(getIt<AuthRepoImpl>()),
            child: OtpScreen(email: state.extra as String),
          );
        },
      ),
      GoRoute(
        path: setPasswordScreen,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => ResetPasswordCubit(getIt<AuthRepoImpl>()),
            child: SetPasswordScreen(),
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
            child: ForgetPasswordScreen(),
          );
        },
      ),
    ],
  );
}
