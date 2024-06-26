import 'package:erps/app/auth/cubit/auth_cubit.dart';
import 'package:erps/app/components/wrapper.dart';
import 'package:erps/features/auth/presentation/pages/v1/forget_password_page.dart';
import 'package:erps/features/auth/presentation/pages/v1/login_page.dart';
import 'package:erps/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> routerList = [];
final anonymous = ['/login', '/forget-password'];

/// RoutePath
const String routePathHomePage = '/';
const String routePathMasterAccessPage = '/access';
const String routePathMasterProgramPage = '/program';
const String routePathMasterModulePage = '/module';

/// RouteName
const String routeNameHomePage = 'home';
const String routeNameMasterAccessPage = 'access';
const String routeNameMasterProgramPage = 'program';
const String routeNameMasterModulePage = 'module';

final appRouter = GoRouter(
    routes: routerList,
    // navigatorKey: Catcher.navigatorKey,
    routerNeglect: true,
    initialLocation: "/",
    redirect: (context, state) {
      final loggedIn =
          BlocProvider.of<AuthCubit>(context).state is Authenticated;
      final gotoAnonymous = anonymous.contains(state.matchedLocation);
      if (!loggedIn && !gotoAnonymous) {
        return '/login?redirect=${state.uri.path.toString()}';
      }

      if (loggedIn && state.matchedLocation == "/login") {
        if (state.uri.queryParameters.containsKey("redirect")) {
          return state.uri.queryParameters["redirect"];
        } else {
          return '/';
        }
      }
      return null;
    });

void populateRoutes(
    LocalKey scaffoldKey, ScrollController horizontalController) {
  routerList.add(GoRoute(
      path: routePathHomePage,
      name: routeNameHomePage,
      pageBuilder: (context, state) {
        return FadeTransitionPage(
          child: Wrapper(
            verticalController: horizontalController,
            child: WrapperWidget(child: const HomePage()),
          ),
          key: scaffoldKey,
        );
      }));
  routerList.add(GoRoute(
      path: routePathMasterAccessPage,
      name: routeNameMasterAccessPage,
      pageBuilder: (context, state) {
        return FadeTransitionPage(
          child: Wrapper(
            verticalController: horizontalController,
            // child: WrapperWidget(child: const AccessScreen()),
          ),
          key: scaffoldKey,
        );
      }));

  routerList.add(GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        return LoginPage(
          redirectTo: state.uri.queryParameters['redirect'] ?? '',
        );
      }));

  routerList.add(
    GoRoute(
        path: '/forget-password',
        name: 'forget-password',
        builder: (context, state) {
          return const ForgetPasswordPage();
        }),
  );
}

class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({
    required LocalKey super.key,
    required super.child,
  }) : super(
            transitionsBuilder: (context, animation1, animation2, child) =>
                FadeTransition(
                  opacity: animation1.drive(_curveTween),
                  child: child,
                ));

  static final _curveTween = CurveTween(curve: Curves.easeIn);
}
