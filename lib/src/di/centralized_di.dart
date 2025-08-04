import 'package:ag/ag.dart';
import 'package:di/di.dart';
import '../data/api/centralized_auth_api.dart';
import '../data/local/centralized_local.dart';
import '../data/repo/centralized_repo.dart';
import '../services/centralized_service.dart';

class AuthCentralizedDependency implements BaseDependencies {
  @override
  void apiDependency() {
    final dependencies = Dependencies();

    dependencies.registerFactory<CentralizedAuthApi>(
      () => CentralizedAuthApiImpl(
        dio: Dio(
          BaseOptions(
              baseUrl: 'https://keycloak-uat.congtrinhviettel.com.vn/realms'),
        ),
      ),
    );

    dependencies.registerFactory<CentralizedAuthLocal>(
      () => AuthLocalStorageImpl(storage: dependencies.getIt()),
    );
  }

  @override
  void repositoryDependency() {
    final dependencies = Dependencies();

    dependencies.registerLazySingleton<CentralizedAuthRepository>(
      () => CentralizedAuthRepositoryImpl(
        centralizedAuthApi: dependencies.getIt(),
        centralizedAuthLocal: dependencies.getIt(),
      ),
    );
  }

  @override
  void init() {
    apiDependency();
    repositoryDependency();

    Dependencies().registerLazySingleton<CentralizedService>(
      () => CentralizedService(Dependencies().getIt()),
    );
  }
}
