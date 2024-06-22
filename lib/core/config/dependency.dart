import 'package:erps/core/config/config.dart';
import 'package:erps/core/data/repositories/v1/auth_local_repository.dart';
import 'package:erps/core/local_store/implement/secure_local_store_client.dart';
import 'package:erps/core/network/http/implement/http_client.dart';
import 'package:erps/features/auth/data/repositories/v1/auth_repository.dart';
import 'package:erps/features/auth/data/services/v1/auth_service.dart';
import 'package:erps/features/auth/domain/repositories/v1/abs_auth_repository.dart';
import 'package:erps/features/auth/domain/services/v1/abs_auth_service.dart';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'injector_dependency_name.dart';

class Dependency {
  static void init() {
    final getIt = GetIt.instance;

    /// client
    String? apiHost = Config.getString("API_HOST") ;
    var httpRestClient = HttpClient(
        host: Config.getString("API_HOST") ?? "",
        apiKey: "",
        client: http.Client());
    var secureLocalStoreClient = SecureLocalStoreClient();

    /// repository
    var secureLocalAuthRepository = AuthLocalRepository(
        client: secureLocalStoreClient,
        storeKey: Config.getString("ACCESS_TOKEN_STORE_KEY") ?? "");
    var authRepository = AuthRepository(client: httpRestClient);
    // var statusRepository = StatusRepository(client: httpRestClient);

    /// repository GetIt
    getIt.registerSingleton<AbsAuthRepository>(authRepository,
        instanceName: InjectorDependencyName.authRepository);
    // getIt.registerSingleton<AbsStatusRepository>(statusRepository,
    //     instanceName: InjectorDependencyName.statusRepository);

    /// service
    var authService = AuthService(
        repo: authRepository,
        localRepo: secureLocalAuthRepository,
        client: httpRestClient);
    // var statusService = StatusService(statusRepository: statusRepository);

    /// service GetIt
    getIt.registerSingleton<AbsAuthService>(authService,
        instanceName: InjectorDependencyName.authService);
    // getIt.registerSingleton<AbsStatusService>(statusService,
    //     instanceName: InjectorDependencyName.statusService);
  }
}
