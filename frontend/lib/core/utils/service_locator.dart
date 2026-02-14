import 'package:get_it/get_it.dart';
import 'package:medi/core/network/api_service.dart';
import 'package:medi/features/auth/data/repo/auth_repo_impl.dart';

final getIt = GetIt.instance;
void setupServiceLocator() {
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<AuthRepoImpl>(
    () => AuthRepoImpl(getIt<ApiService>()),
  );
}
