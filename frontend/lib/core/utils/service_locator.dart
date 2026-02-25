import 'package:get_it/get_it.dart';
import 'package:medi/core/network/api_service.dart';
import 'package:medi/core/services/audio_player_service.dart';
import 'package:medi/features/shared/auth/data/repo/auth_repo_impl.dart';
import 'package:medi/features/patient/features/notification_sound/data/datasources/local_sound_datasource.dart';
import 'package:medi/features/patient/features/notification_sound/data/datasources/local_sound_datasource_impl.dart';
import 'package:medi/features/patient/features/notification_sound/data/repo/sound_repo.dart';
import 'package:medi/features/patient/features/notification_sound/data/repo/sound_repo_impl.dart';
import 'package:medi/features/patient/features/notification_sound/domain/usecases/get_sounds_usecase.dart';
import 'package:medi/features/patient/features/notification_sound/domain/usecases/preview_sound_usecase.dart';
import 'package:medi/features/patient/features/notification_sound/domain/usecases/save_sound_usecase.dart';
import 'package:medi/features/patient/features/notification_sound/presentation/controller/sound_cubit/sound_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;
void setupServiceLocator() async {
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<AuthRepoImpl>(
    () => AuthRepoImpl(getIt<ApiService>()),
  );
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<LocalSoundDataSource>(
    () => LocalSoundDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<SoundRepository>(
    () => SoundRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<AudioPlayerService>(() => AudioPlayerService());
  getIt.registerLazySingleton(() => GetSoundsUseCase(getIt()));

  getIt.registerLazySingleton(() => SaveSoundUseCase(getIt()));

  getIt.registerLazySingleton(
    () => PreviewSoundUseCase(
      getIt(), // AudioPlayerService
    ),
  );
  getIt.registerFactory(
    () => SoundCubit(
      getIt<LocalSoundDataSource>(),
      previewSound: getIt(),
      getSounds: getIt(),
      saveSound: getIt(),
    ),
  );
}
