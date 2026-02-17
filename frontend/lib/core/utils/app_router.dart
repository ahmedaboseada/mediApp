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
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/allow_location_screen.dart';
import 'package:medi/features/doctor/features/complete_profile/presentation/screens/doctor_complete_profile.dart';
import 'package:medi/features/doctor/features/home/presentation/screens/main_layout.dart';
import 'package:medi/features/doctor/features/settings/presentation/controller/cubit/schedule_cubit.dart';
import 'package:medi/features/doctor/features/settings/presentation/screens/account_information_screen.dart';
import 'package:medi/features/doctor/features/settings/presentation/screens/payout_withdrawal_screen.dart';
import 'package:medi/features/doctor/features/settings/presentation/screens/schedule_availability_screen.dart';
import 'package:medi/features/patient/home/presentation/screens/home_screen.dart';
import 'package:medi/features/patient/questionnaire/presentation/cubit/cubit/questinnaire_cubit.dart';
import 'package:medi/features/patient/questionnaire/presentation/screens/caregiver_form_screen.dart';
import 'package:medi/features/patient/questionnaire/presentation/screens/invitation_send_screen.dart';
import 'package:medi/features/patient/questionnaire/questionnaire_flow.dart';
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
  static const String profileCompletedScreen = '/profileCompleted';

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

  // ========== DEPRECATED ==========
  static const String emailLoginScreen = '/emailLogin';
  static const String phoneLoginScreen = '/phoneLogin';

  static final router = GoRouter(
    initialLocation: mainLayout,
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
      ),
      GoRoute(
        path: caregiverFormScreen,
        builder: (context, state) {
          return CaregiverFormScreen();
        },
      ),
      GoRoute(
        path: invitationSendScreen,
        builder: (context, state) {
          return InvitationSendScreen();
        },
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
        path: profileCompletedScreen,
        builder: (context, state) {
          return const ProfileCompleted();
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
