import 'package:get_it/get_it.dart';
import 'package:mobile/core/repositories/repositories.dart';
import 'package:mobile/core/services/services.dart';

final locator = GetIt.instance;

void setupServiceLocator() {
  locator
    ..registerLazySingleton<ApiClient>(() => ApiClient())
    ..registerLazySingleton<AuthService>(() => AuthService())
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepository(service: locator<AuthService>()),
    );
}