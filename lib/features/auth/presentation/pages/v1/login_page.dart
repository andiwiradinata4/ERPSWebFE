import 'package:erps/app/auth/cubit/auth_cubit.dart';
import 'package:erps/app/components/us_dialog_builder.dart';
import 'package:erps/app/components/us_snackbar_builder.dart';
import 'package:erps/app/components/us_text_form_field.dart';
import 'package:erps/core/config/responsive.dart';
import 'package:erps/core/config/size_config.dart';
import 'package:erps/features/auth/presentation/bloc/v1/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  final String redirectTo;

  const LoginPage({super.key, required this.redirectTo});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // appBar: AppBar(),
      body: Responsive(
        desktop: Desktop(
          redirectTo: widget.redirectTo,
        ),
        mobile: Mobile(
          redirectTo: widget.redirectTo,
        ),
        tablet: Desktop(
          redirectTo: widget.redirectTo,
        ),
      ),
    );
  }
}

class Desktop extends StatefulWidget {
  final String redirectTo;

  const Desktop({super.key, required this.redirectTo});

  @override
  State<Desktop> createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late LoginBloc _loginBloc;
  late AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();

    /// Get Login Bloc
    _loginBloc = context.read<LoginBloc>();

    /// Get Auth Cubit
    _authCubit = context.read<AuthCubit>();
  }

  void fLogin() {
    if (formKey.currentState!.validate()) {
      _loginBloc.add(LoginAuthEvent(
          username: usernameController.text.trim(),
          password: passwordController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listenWhen: (previousState, state) {
          if (previousState is LoginLoadingState) {
            UsDialogBuilder.dispose();
          }
          return true;
        },
        listener: ((context, state) {
          if (state is LoginErrorState) {
            Future.delayed(Duration.zero, () {
              UsSnackBarBuilder.showErrorSnackBar(context, state.message);
            });
          } else if (state is LoginLoadingState) {
            Future.delayed(Duration.zero,
                () => UsDialogBuilder.loadLoadingDialog(context));
          } else if (state is LoginSuccessState) {
          } else if (state is SuccessGetDetailState) {
            _authCubit.setAsAuthenticated(state.user);
            if (widget.redirectTo.isNotEmpty) {
              GoRouter.of(context).pushReplacement(widget.redirectTo);
            } else {
              GoRouter.of(context).pushReplacementNamed('home');
            }
          }
        }),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Row(
              children: [
                Container(
                  width: SizeConfig.screenWidth * 0.5,
                  height: SizeConfig.screenHeight,
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
                Container(
                  width: SizeConfig.screenWidth * 0.5,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header Text
                      const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w700,
                            height: 1.5),
                      ),

                      /// Welcome Text
                      const Text(
                        'Silahkan Masukkan Akun Anda',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            height: 1.5),
                      ),

                      /// Spacer
                      const SizedBox(
                        height: 50,
                      ),

                      /// Username
                      UsTextFormField(
                        fieldName: 'Username',
                        usController: usernameController,
                        textInputType: TextInputType.emailAddress,
                        validateValue: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan username terlebih dahulu';
                          }

                          return null;
                        },
                      ),

                      /// Spacer
                      const SizedBox(
                        height: 40,
                      ),

                      /// Password
                      UsTextFormField(
                        fieldName: 'Password',
                        usController: passwordController,
                        textInputType: TextInputType.visiblePassword,
                        validateValue: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan password terlebih dahulu';
                          }

                          return null;
                        },
                        useSuffixIcon: true,
                        activeSuffixIcon: Icons.visibility_outlined,
                        deactiveSuffixIcon: Icons.visibility_off_outlined,
                        isPasswordHandle: true,
                      ),

                      /// Spacer
                      const SizedBox(
                        height: 10,
                      ),

                      /// Forget Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () => GoRouter.of(context).go('/forget-password'),
                            child: const Text(
                              'Lupa Password?',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            )),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      /// Login Button
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: SizeConfig.screenWidth,
                          child: ElevatedButton(
                              onPressed: fLogin,
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w800),
                              )),
                        ),
                      ),

                      /// Spacer
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class Mobile extends StatefulWidget {
  final String redirectTo;

  const Mobile({super.key, required this.redirectTo});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late LoginBloc _loginBloc;
  late AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();

    /// Get Login Bloc
    _loginBloc = context.read<LoginBloc>();

    /// Get Auth Cubit
    _authCubit = context.read<AuthCubit>();
  }

  void fLogin() {
    if (formKey.currentState!.validate()) {
      _loginBloc.add(LoginAuthEvent(
          username: usernameController.text.trim(),
          password: passwordController.text.trim()));
    }
  }

  void fForgetPassword() => GoRouter.of(context).go('/forget-password');

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listenWhen: (previousState, state) {
          if (previousState is LoginLoadingState) {
            UsDialogBuilder.dispose();
          }
          return true;
        },
        listener: ((context, state) {
          if (state is LoginErrorState) {
            Future.delayed(Duration.zero, () {
              UsSnackBarBuilder.showErrorSnackBar(context, state.message);
            });
          } else if (state is LoginLoadingState) {
            Future.delayed(Duration.zero,
                () => UsDialogBuilder.loadLoadingDialog(context));
          } else if (state is LoginSuccessState) {
          } else if (state is SuccessGetDetailState) {
            _authCubit.setAsAuthenticated(state.user);
            if (widget.redirectTo.isNotEmpty) {
              GoRouter.of(context).pushReplacement(widget.redirectTo);
            } else {
              GoRouter.of(context).pushReplacementNamed('home');
            }
          }
        }),
        child: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.9,
                height: SizeConfig.screenHeight,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.screenWidth * 0.1),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Spacer
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.3,
                          ),

                          Column(
                            children: [
                              /// Header Text
                              const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5),
                              ),

                              /// Welcome Text
                              const Text(
                                'Silahkan Masukkan Akun Anda',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5),
                              ),

                              /// Spacer
                              const SizedBox(
                                height: 18,
                              ),

                              /// Username
                              UsTextFormField(
                                fieldName: 'Username',
                                usController: usernameController,
                                textInputType: TextInputType.emailAddress,
                                validateValue: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukan username terlebih dahulu';
                                  }

                                  return null;
                                },
                              ),

                              /// Spacer
                              const SizedBox(
                                height: 15,
                              ),

                              /// Password
                              UsTextFormField(
                                fieldName: 'Password',
                                usController: passwordController,
                                textInputType: TextInputType.visiblePassword,
                                validateValue: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Masukan password terlebih dahulu';
                                  }

                                  return null;
                                },
                                useSuffixIcon: true,
                                activeSuffixIcon: Icons.visibility_outlined,
                                deactiveSuffixIcon:
                                    Icons.visibility_off_outlined,
                                isPasswordHandle: true,
                              ),

                              /// Spacer
                              const SizedBox(
                                height: 10,
                              ),

                              /// Forget Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                    onPressed: () {
                                      GoRouter.of(context).go('/forget-password');
                                    },
                                    child: const Text(
                                      'Lupa Password?',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// Login Button
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.screenHeight * 0.8),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: SizeConfig.screenWidth,
                            child: ElevatedButton(
                                onPressed: fLogin,
                                child: const Text(
                                  'Masuk',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
