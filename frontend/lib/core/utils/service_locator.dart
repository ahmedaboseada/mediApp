import 'package:get_it/get_it.dart';
import 'package:medi/core/network/api_service.dart';
import 'package:medi/core/services/audio_player_service.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo.dart';
import 'package:medi/features/patient/features/add_medication/data/repo/medicine_repo_impl.dart';
import 'package:medi/features/patient/features/add_medication/presentation/cubit/medicine_cubit.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo.dart';
import 'package:medi/features/doctor/features/complete_profile/data/repo/doctor_complete_profile_repo_impl.dart';
import 'package:medi/features/doctor/features/home/data/repo/appointments_repository.dart';
import 'package:medi/features/doctor/features/home/data/repo/appointments_repository_impl.dart';
import 'package:medi/features/doctor/features/home/presentation/cubit/appointments_cubit.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/doctor/features/patients/data/repo/patients_repository.dart';
import 'package:medi/features/doctor/features/patients/data/repo/patients_repository_impl.dart';
import 'package:medi/features/doctor/features/patients/presentation/cubit/patients_cubit.dart';
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
import 'package:medi/features/patient/features/questionnaire/data/repo/questionnaire_repo.dart';
import 'package:medi/features/patient/features/questionnaire/data/repo/questionnaire_repo_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;
Future<void> setupServiceLocator() async {
  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(() => ApiService());
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
  if (!getIt.isRegistered<ProfileCubit>()) {
    getIt.registerFactory<ProfileCubit>(
      () => ProfileCubit(getIt<ProfileRepo>()),
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
      () => PatientsRepositoryImpl(),
    );
  }
  if (!getIt.isRegistered<PatientsCubit>()) {
    getIt.registerFactory<PatientsCubit>(
      () => PatientsCubit(getIt<PatientsRepository>()),
    );
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
}
