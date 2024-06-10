import 'package:erps/core/config/config.dart';
import 'package:erps/core/local_store/implement/secure_local_store_client.dart';
import 'package:erps/core/network/http/implement/http_client.dart';
import 'package:erps/features/master/status/data/repository/abstract/v1/abs_status_repository.dart';
import 'package:erps/features/master/status/data/repository/implement/v1/status_repository.dart';
import 'package:erps/features/master/status/data/service/v1/abstract/abs_status_service.dart';
import 'package:erps/features/master/status/data/service/v1/implement/status_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'injector_dependency_name.dart';

class Dependency {
  static void init() {
    final getIt = GetIt.instance;

    /// client
    var httpRestClient = HttpClient(
        host: Config.getString("API_HOST") ?? "",
        apiKey: Config.getString("API_KEY") ?? "",
        client: http.Client());
    var secureLocalStoreClient = SecureLocalStoreClient();

    /// repository
    // var secureLocalAuthRepository = SecureLocalAuthRepository(
    //     client: secureLocalStoreClient,
    //     storeKey: Config.getString("ACCESS_TOKEN_STORE_KEY") ?? "");
    // var authRepository = AuthRepository(client: httpRestClient);
    var statusRepository = StatusRepository(client: httpRestClient);

    /// repository GetIt
    // getIt.registerSingleton<AbsAuthRepository>(authRepository,
    //     instanceName: InjectorDependencyName.authRepository);
    getIt.registerSingleton<AbsStatusRepository>(statusRepository,
        instanceName: InjectorDependencyName.statusRepository);

    /// service
    // var authService = AuthService(
    //     localAuthRepo: secureLocalAuthRepository,
    //     authRepo: authRepository,
    //     httpClient: httpRestClient);
    var statusService = StatusService(statusRepository: statusRepository);

    /// service GetIt
    // getIt.registerSingleton<AbsAuthService>(authService,
    //     instanceName: InjectorDependencyName.authService);
    getIt.registerSingleton<AbsStatusService>(statusService,
        instanceName: InjectorDependencyName.statusService);
  }
}
