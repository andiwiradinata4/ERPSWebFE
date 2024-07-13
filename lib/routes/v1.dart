import 'package:erps/app/auth/cubit/auth_cubit.dart';
import 'package:erps/app/components/wrapper.dart';
import 'package:erps/features/auth/presentation/pages/v1/create_password_page.dart';
import 'package:erps/features/auth/presentation/pages/v1/forget_password_page.dart';
import 'package:erps/features/auth/presentation/pages/v1/my_account_page.dart';
import 'package:erps/features/auth/presentation/pages/v1/verify_token_page.dart';
import 'package:erps/features/auth/presentation/pages/v1/login_page.dart';
import 'package:erps/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final List<RouteBase> routerList = [];
final anonymous = [
  routePathLoginPage,
  routePathForgetPasswordPage,
  routePathVerifyTokenPage,
  routePathCreatePasswordPage
];

/// RoutePath
const String routePathHomePage = '/';
const String routePathLoginPage = '/login';
const String routePathForgetPasswordPage = '/forget-password';
const String routePathVerifyTokenPage = '/verify-token';
const String routePathCreatePasswordPage = '/create-password';
const String routePathMyAccountPage = '/my-account';
const String routePathMasterAccessPage = '/access';
const String routePathMasterProgramPage = '/program';
const String routePathMasterModulePage = '/module';

/// RouteName
const String routeNameHomePage = 'home';
const String routeNameLoginPage = 'login';
const String routeNameForgetPasswordPage = 'forget-password';
const String routeNameVerifyTokenPage = 'verify-token';
const String routeNameCreatePasswordPage = 'create-password';
const String routeNameMyAccountPage = 'my-account';
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
        return '$routePathLoginPage?redirect=${state.uri.path.toString()}';
      }

      if (loggedIn && state.matchedLocation == routePathLoginPage) {
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
  /// Home Page
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

  /// Authentication
  routerList.add(GoRoute(
    path: routePathLoginPage,
    name: routeNameLoginPage,
    builder: (context, state) {
      return LoginPage(
        redirectTo: state.uri.queryParameters['redirect'] ?? '',
      );
    },
  ));

  routerList.add(
    GoRoute(
        path: routePathForgetPasswordPage,
        name: routeNameForgetPasswordPage,
        builder: (context, state) {
          return const ForgetPasswordPage();
        }),
  );

  routerList.add(
    GoRoute(
        path: routePathVerifyTokenPage,
        name: routeNameVerifyTokenPage,
        builder: (context, state) {
          String process = '';
          String references = '';
          String accessToken = '';
          String code = '';
          Object? extra = state.extra;
          if (extra != null) {
            if (extra is Map<String, String>) {
              process = extra['process'] ?? '';
              references = extra['references'] ?? '';
              accessToken = extra['accessToken'] ?? '';
              code = extra['code'] ?? '';
            }
          }
          return VerifyTokenPage(
            process: process,
            references: references,
            accessToken: accessToken,
            code: code,
          );
        }),
  );

  routerList.add(
    GoRoute(
        path: routePathCreatePasswordPage,
        name: routeNameCreatePasswordPage,
        builder: (context, state) {
          String references = '';
          String accessToken = '';
          String code = '';
          Object? extra = state.extra;
          if (extra != null) {
            if (extra is Map<String, String>) {
              references = extra['references'] ?? '';
              accessToken = extra['accessToken'] ?? '';
              code = extra['code'] ?? '';
            }
          }
          return CreatePasswordPage(
            references: references,
            accessToken: accessToken,
            code: code,
          );
        }),
  );

  /// My Account Page
  routerList.add(GoRoute(
      path: routePathMyAccountPage,
      name: routeNameMyAccountPage,
      pageBuilder: (context, state) {
        return FadeTransitionPage(
          child: Wrapper(
            verticalController: horizontalController,
            child: WrapperWidget(child: const MyAccountPage()),
          ),
          key: scaffoldKey,
        );
      }));
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
