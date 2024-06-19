import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:erps/app/auth/cubit/auth_cubit.dart';
import 'package:erps/app/init/cubit/app_init_cubit.dart';
import 'package:erps/core/config/config.dart';
import 'package:erps/core/config/dependency.dart';
import 'package:erps/core/config/injector_dependency_name.dart';
import 'package:erps/features/auth/data/models/user.dart';
import 'package:erps/features/auth/domain/services/v1/abs_auth_service.dart';
import 'package:erps/flavors.dart';
import 'package:get_it/get_it.dart';

Future<void> init(AppInitCubit initCubit, AuthCubit authCubit) async {
  try {
    initCubit.setAsInitiating();
    await readEnv();
    Dependency.init();
    await initAuthState(
        authCubit,
        GetIt.I.get<AbsAuthService>(
            instanceName: InjectorDependencyName.authService));

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // await readRemoteConfig();
    // @TODO init FCM Here

    initCubit.setAsInitiated();
  } catch (ex) {
    initCubit.setAsFailInitiated(ex as Exception);
  }
}

Future<void> readEnv() async {
  var envFile = ".env.dev";
  if (F.appFlavor == Flavor.prod) {
    envFile = ".env.prod";
  }
  try {
    await dotenv.load(fileName: envFile);
    Config.addAll(dotenv.env);
  } catch (e) {
    throw Exception("Fail to read environment variable. Filename : $envFile");
  }
}

Future<void> readRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(seconds: 1),
  ));
  await remoteConfig.fetchAndActivate();
  Map<String, dynamic> configs = <String, dynamic>{};
  for (String key in remoteConfig.getAll().keys) {
    configs[key] = remoteConfig.getString(key);
  }
  Config.addAll(configs);
}

Future<void> initAuthState(
    AuthCubit authCubit, AbsAuthService authService) async {
  User? user = await authService.initAuthState();
  if (user != null) {
    authCubit.setAsAuthenticated(user);
  } else {
    authCubit.setAsAnonymous();
  }
}
