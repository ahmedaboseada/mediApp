import 'package:get_it/get_it.dart';
import 'package:medi/core/network/api_service.dart';
import 'package:medi/core/state/caregiver_mode_cubit.dart';
import 'package:medi/core/state/managed_patient_dashboard_cubit.dart';
import 'package:medi/core/services/audio_player_service.dart';
import 'package:medi/core/services/payment_flow_cache.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo_impl.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo_impl.dart';
import 'package:medi/features/doctor/features/settings/data/repo/wallet_repo.dart';
import 'package:medi/features/doctor/features/settings/data/repo/wallet_repo_impl.dart';
import 'package:medi/features/doctor/features/settings/presentation/controller/cubit/wallet_cubit.dart';
import 'package:medi/features/doctor/features/home/data/repo/appointments_repository.dart';
import 'package:medi/features/doctor/features/home/data/repo/appointments_repository_impl.dart';
import 'package:medi/features/doctor/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:medi/features/patient/features/home/data/repo/sos_repo.dart';
import 'package:medi/features/patient/features/home/data/repo/sos_repo_impl.dart';
import 'package:medi/features/patient/features/home/presentation/controller/sos/sos_cubit.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/doctor/features/patients/data/repo/patients_repository.dart';
import 'package:medi/features/doctor/features/patients/data/repo/patients_repository_impl.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/patients/patients_cubit.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/add_patient/add_patient_cubit.dart';
import 'package:medi/features/doctor/features/patients/data/repo/booking_session_repository.dart';
import 'package:medi/features/doctor/features/patients/data/repo/booking_session_repository_impl.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/booking_session/booking_session_cubit.dart';
import 'package:medi/features/doctor/features/patients/data/repo/manage_meds/manage_meds_repo.dart';
import 'package:medi/features/doctor/features/patients/data/repo/manage_meds/manage_meds_repo_impl.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/manage_meds/mange_meds_cubit.dart';
import 'package:medi/features/patient/features/doctors/data/repo/booking_qr_repository.dart';
import 'package:medi/features/patient/features/doctors/data/repo/booking_qr_repository_impl.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo.dart';
import 'package:medi/features/patient/features/doctors/data/repo/doctors_repo_impl.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/add_doctor_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/booking_qr_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/connected_doctors_cubit.dart';
import 'package:medi/features/patient/features/doctors/presentation/cubits/doctors_cubit.dart';
import 'package:medi/features/patient/features/notification_sound/data/datasources/local_sound_datasource.dart';
import 'package:medi/features/patient/features/notification_sound/data/datasources/local_sound_datasource_impl.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo.dart';
import 'package:medi/features/patient/features/health_measurements/data/repo/logs_repo_impl.dart';
import 'package:medi/features/patient/features/notification_sound/data/repo/sound_repo.dart';
import 'package:medi/features/patient/features/notification_sound/data/repo/sound_repo_impl.dart';
import 'package:medi/features/patient/features/notification_sound/domain/usecases/get_sounds_usecase.dart';
import 'package:medi/features/patient/features/notification_sound/domain/usecases/preview_sound_usecase.dart';
import 'package:medi/features/patient/features/notification_sound/domain/usecases/save_sound_usecase.dart';
import 'package:medi/features/patient/features/notification_sound/presentation/controller/sound_cubit/sound_cubit.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo.dart';
import 'package:medi/features/patient/features/profile/data/repo/profile_repo_impl.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/profile/profile_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/health_report_export/health_report_export_cubit.dart';
import 'package:medi/features/patient/features/profile/presentation/controller/health_passport_export/health_passport_export_cubit.dart';
import 'package:medi/features/patient/features/questionnaire/data/repo/questionnaire_repo.dart';
import 'package:medi/features/patient/features/questionnaire/data/repo/questionnaire_repo_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;
Future<void> setupServiceLocator() async {
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(() => ApiService());
  }
  if (!getIt.isRegistered<CaregiverModeCubit>()) {
    getIt.registerLazySingleton<CaregiverModeCubit>(() => CaregiverModeCubit());
  }
  if (!getIt.isRegistered<ManagedPatientDashboardCubit>()) {
    getIt.registerLazySingleton<ManagedPatientDashboardCubit>(
      () => ManagedPatientDashboardCubit(
        getIt<ApiService>(),
        getIt<CaregiverModeCubit>(),
      ),
    );
  }
  if (!getIt.isRegistered<MedicineRepo>()) {
    getIt.registerLazySingleton<MedicineRepo>(
      () => MedicineRepoImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<MedicineCubit>()) {
    getIt.registerFactory<MedicineCubit>(
      () => MedicineCubit(getIt<MedicineRepo>()),
    );
  }
  if (!getIt.isRegistered<AuthRepoImpl>()) {
    getIt.registerLazySingleton<AuthRepoImpl>(
      () => AuthRepoImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<ProfileRepo>()) {
    getIt.registerLazySingleton<ProfileRepo>(
      () => ProfileRepoImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<AuthRepo>()) {
    getIt.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<ProfileCubit>()) {
    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(getIt<ProfileRepo>()),
    );
  }
  if (!getIt.isRegistered<HealthPassportExportCubit>()) {
    getIt.registerFactory<HealthPassportExportCubit>(
      () => HealthPassportExportCubit(getIt<ProfileRepo>()),
    );
  }
  if (!getIt.isRegistered<HealthReportExportCubit>()) {
    getIt.registerFactory<HealthReportExportCubit>(
      () => HealthReportExportCubit(getIt<ProfileRepo>()),
    );
  }
  if (!getIt.isRegistered<QRTokenCubit>()) {
    getIt.registerFactory<QRTokenCubit>(
      () => QRTokenCubit(getIt<ProfileRepo>()),
    );
  }
  if (!getIt.isRegistered<SharedRecordDownloadCubit>()) {
    getIt.registerFactory<SharedRecordDownloadCubit>(
      () => SharedRecordDownloadCubit(getIt<ProfileRepo>()),
    );
  }
  if (!getIt.isRegistered<QuestionnaireRepo>()) {
    getIt.registerLazySingleton<QuestionnaireRepo>(
      () => QuestionnaireRepoImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<LogsRepo>()) {
    getIt.registerLazySingleton<LogsRepo>(
      () => LogsRepoImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<DoctorCompleteProfileRepo>()) {
    getIt.registerLazySingleton<DoctorCompleteProfileRepo>(
      () => DoctorCompleteProfileRepoImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<AppointmentsRepository>()) {
    getIt.registerLazySingleton<AppointmentsRepository>(
      () => AppointmentsRepositoryImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<AppointmentsCubit>()) {
    getIt.registerFactory<AppointmentsCubit>(
      () => AppointmentsCubit(getIt<AppointmentsRepository>()),
    );
  }
  if (!getIt.isRegistered<PatientsRepository>()) {
    getIt.registerLazySingleton<PatientsRepository>(
      () => PatientsRepositoryImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<PatientsCubit>()) {
    getIt.registerFactory<PatientsCubit>(
      () => PatientsCubit(getIt<PatientsRepository>()),
    );
  }
  if (!getIt.isRegistered<AddPatientCubit>()) {
    getIt.registerFactory<AddPatientCubit>(
      () => AddPatientCubit(getIt<PatientsRepository>()),
    );
  }
  if (!getIt.isRegistered<BookingSessionRepository>()) {
    getIt.registerLazySingleton<BookingSessionRepository>(
      () => BookingSessionRepositoryImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<BookingSessionCubit>()) {
    getIt.registerFactory<BookingSessionCubit>(
      () => BookingSessionCubit(getIt<BookingSessionRepository>()),
    );
  }
  if (!getIt.isRegistered<ManageMedsRepo>()) {
    getIt.registerLazySingleton<ManageMedsRepo>(
      () => ManageMedsRepoImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<ManageMedsCubit>()) {
    getIt.registerFactory<ManageMedsCubit>(
      () => ManageMedsCubit(getIt<ManageMedsRepo>()),
    );
  }
  if (!getIt.isRegistered<WalletRepo>()) {
    getIt.registerLazySingleton<WalletRepo>(
      () => WalletRepoImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<WalletCubit>()) {
    getIt.registerFactory<WalletCubit>(() => WalletCubit(getIt<WalletRepo>()));
  }
  final sharedPreferences = await SharedPreferences.getInstance();
  if (!getIt.isRegistered<SharedPreferences>()) {
    getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  }
  if (!getIt.isRegistered<LocalSoundDataSource>()) {
    getIt.registerLazySingleton<LocalSoundDataSource>(
      () => LocalSoundDataSourceImpl(getIt()),
    );
  }
  if (!getIt.isRegistered<SoundRepository>()) {
    getIt.registerLazySingleton<SoundRepository>(
      () => SoundRepositoryImpl(getIt()),
    );
  }
  if (!getIt.isRegistered<AudioPlayerService>()) {
    getIt.registerLazySingleton<AudioPlayerService>(() => AudioPlayerService());
  }
  if (!getIt.isRegistered<PaymentFlowCache>()) {
    getIt.registerLazySingleton<PaymentFlowCache>(() => PaymentFlowCache());
  }
  if (!getIt.isRegistered<GetSoundsUseCase>()) {
    getIt.registerLazySingleton<GetSoundsUseCase>(
      () => GetSoundsUseCase(getIt()),
    );
  }

  if (!getIt.isRegistered<SaveSoundUseCase>()) {
    getIt.registerLazySingleton<SaveSoundUseCase>(
      () => SaveSoundUseCase(getIt()),
    );
  }

  if (!getIt.isRegistered<PreviewSoundUseCase>()) {
    getIt.registerLazySingleton<PreviewSoundUseCase>(
      () => PreviewSoundUseCase(
        getIt(), // AudioPlayerService
      ),
    );
  }
  if (!getIt.isRegistered<SoundCubit>()) {
    getIt.registerFactory<SoundCubit>(
      () => SoundCubit(
        getIt<LocalSoundDataSource>(),
        previewSound: getIt(),
        getSounds: getIt(),
        saveSound: getIt(),
      ),
    );
  }

  if (!getIt.isRegistered<DoctorsRepository>()) {
    getIt.registerLazySingleton<DoctorsRepository>(
      () => DoctorsRepositoryImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<BookingQrRepository>()) {
    getIt.registerLazySingleton<BookingQrRepository>(
      () => BookingQrRepositoryImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<BookingQrCubit>()) {
    getIt.registerFactory<BookingQrCubit>(
      () => BookingQrCubit(getIt<BookingQrRepository>()),
    );
  }
  if (!getIt.isRegistered<DoctorsCubit>()) {
    getIt.registerFactory<DoctorsCubit>(
      () => DoctorsCubit(repository: getIt<DoctorsRepository>()),
    );
  }
  if (!getIt.isRegistered<AddDoctorCubit>()) {
    getIt.registerFactory<AddDoctorCubit>(
      () => AddDoctorCubit(getIt<DoctorsRepository>()),
    );
  }
  if (!getIt.isRegistered<ConnectedDoctorsCubit>()) {
    getIt.registerFactory<ConnectedDoctorsCubit>(
      () => ConnectedDoctorsCubit(repository: getIt<DoctorsRepository>()),
    );
  }
  if (!getIt.isRegistered<SosRepo>()) {
    getIt.registerLazySingleton<SosRepo>(
      () => SosRepoImpl(getIt<ApiService>()),
    );
  }
  if (!getIt.isRegistered<SosCubit>()) {
    getIt.registerFactory<SosCubit>(() => SosCubit(getIt<SosRepo>()));
  }
}
