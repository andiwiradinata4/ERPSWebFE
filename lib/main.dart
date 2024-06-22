import 'package:erps/app/auth/cubit/auth_cubit.dart';
import 'package:erps/app/init/app_init.dart';
import 'package:erps/app/init/cubit/app_init_cubit.dart';
import 'package:erps/app/utils/themes/light_theme.dart';
import 'package:erps/core/config/injector_dependency_name.dart';
import 'package:erps/features/auth/presentation/bloc/v1/login_bloc.dart';
import 'package:erps/routes/v1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

void main() {
  myRunApp();
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const scaffoldKey = ValueKey<String>('App scaffold');
    final ScrollController scrollController = ScrollController();

    populateRoutes(scaffoldKey, scrollController);
    return MaterialApp.router(
        showSemanticsDebugger: false,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
        title: 'ERP',
        theme: lightTheme(context));
  }
}

void myRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  // setUrlStrategy(PathUrlStrategy());

  AppInitCubit appInitCubit = AppInitCubit();
  AuthCubit authCubit =
      (GetIt.I.get(instanceName: InjectorDependencyName.authService));

  /// First Init Dependency and All Config
  await init(appInitCubit, authCubit);

  final LoginBloc loginBloc =
      LoginBloc(GetIt.I.get(instanceName: InjectorDependencyName.authService));
  // final AccessBloc accessBloc = AccessBloc(
  //     GetIt.I.get(instanceName: InjectorDependencyName.masterService));

  // final MenuCategoryBloc menuCategoryBloc = MenuCategoryBloc(
  //     GetIt.I.get(instanceName: InjectorDependencyName.masterMerchantService));
  // final VariantGroupBloc variantGroupBloc = VariantGroupBloc(
  //     GetIt.I.get(instanceName: InjectorDependencyName.masterMerchantService));
  // final MenuBloc menuBloc = MenuBloc(
  //     GetIt.I.get(instanceName: InjectorDependencyName.masterProductService));
  //
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => appInitCubit,
    ),
    BlocProvider(
      create: (context) => authCubit,
    ),
    BlocProvider(
      create: (context) => loginBloc,
    ),
    // BlocProvider(
    //   create: (context) => accessBloc,
    // ),
    // BlocProvider(
    //   create: (context) => variantGroupBloc,
    // ),
    // BlocProvider(create: (context) => menuBloc)
  ], child: const MyApp()));
  // runApp(const MyApp());MyApp
}
