import 'package:erps/app/auth/cubit/auth_cubit.dart';
import 'package:erps/app/components/us_snackbar_builder.dart';
import 'package:erps/app/components/us_text_form_field.dart';
import 'package:erps/core/config/responsive.dart';
import 'package:erps/core/config/size_config.dart';
import 'package:erps/features/auth/presentation/bloc/v1/auth_bloc.dart';
import 'package:erps/routes/v1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

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
        desktop: Default(
          redirectTo: widget.redirectTo,
        ),
        mobile: Default(
          redirectTo: widget.redirectTo,
        ),
        tablet: Default(
          redirectTo: widget.redirectTo,
        ),
      ),
    );
  }
}

class Default extends StatefulWidget {
  final String redirectTo;

  const Default({super.key, required this.redirectTo});

  @override
  State<Default> createState() => _DefaultState();
}

class _DefaultState extends State<Default> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  late AuthBloc _authBloc;
  late AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();

    /// Get Login Bloc
    _authBloc = context.read<AuthBloc>();

    /// Get Auth Cubit
    _authCubit = context.read<AuthCubit>();
  }

  void fLogin() {
    if (isLoading) return;
    if (formKey.currentState!.validate()) {
      _authBloc.add(LoginAuthEvent(
          username: usernameController.text.trim(),
          password: passwordController.text.trim()));
    }
  }

  void fForgetPassword() =>
      GoRouter.of(context).pushNamed(routeNameForgetPasswordPage);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listenWhen: (previousState, state) {
          // if (previousState is LoginLoadingState) {
          //   UsDialogBuilder.dispose();
          // }
          return true;
        },
        listener: ((context, state) {
          if (state is LoginErrorState) {
            Future.delayed(Duration.zero, () {
              UsSnackBarBuilder.showErrorSnackBar(context, state.message);
            });
          } else if (state is LoginLoadingState) {
            if (mounted) {
              setState(() {
                isLoading = true;
              });
            }
            // Future.delayed(Duration.zero,
            //     () => UsDialogBuilder.loadLoadingDialog(context));
          } else if (state is LoginSuccessState) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          } else if (state is SuccessGetDetailState) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
            _authCubit.setAsAuthenticated(state.user);
            if (widget.redirectTo.isNotEmpty) {
              GoRouter.of(context).pushReplacement(widget.redirectTo);
            } else {
              GoRouter.of(context).pushReplacementNamed(routeNameHomePage);
            }
          }
        }),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child:
                (Responsive.isMobile(context)) ? mobileView() : desktopView(),
          ),
        ));
  }

  Row mobileView() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            // height: SizeConfig.screenHeight,
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.1),
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
                            deActiveSuffixIcon: Icons.visibility_off_outlined,
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
                                onPressed: fForgetPassword,
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
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight * 0.9),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: SizeConfig.screenWidth,
                        child: ElevatedButton(
                            onPressed: fLogin,
                            child: (isLoading)
                                ? SizedBox(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Loading ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white),
                                    ),
                                    Lottie.asset(
                                        'lib/assets/lottie/loading.json',
                                        repeat: true),
                                  ],
                                ))
                                : const Text(
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
      );

  Row desktopView() => Row(
        children: [
          Container(
            width: SizeConfig.screenWidth * 0.5,
            height: SizeConfig.screenHeight,
            color: Theme.of(context).primaryColor.withOpacity(0.8),
          ),
          Container(
            width: SizeConfig.screenWidth * 0.5,
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Text
                const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 50, fontWeight: FontWeight.w700, height: 1.5),
                ),

                /// Welcome Text
                const Text(
                  'Silahkan Masukkan Akun Anda',
                  style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w700, height: 1.5),
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
                  deActiveSuffixIcon: Icons.visibility_off_outlined,
                  isPasswordHandle: true,
                  onFieldSubmitted: (String? value) => fLogin(),
                ),

                /// Spacer
                const SizedBox(
                  height: 10,
                ),

                /// Forget Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: fForgetPassword,

                      /// GoRouter.of(context).go('/forget-password'),
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
                        onPressed: (isLoading) ? () {} : fLogin,
                        child: (isLoading)
                            ? SizedBox(
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Loading ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white),
                                    ),
                                    Lottie.asset(
                                        'lib/assets/lottie/loading.json',
                                        repeat: true),
                                  ],
                                ))
                            : const Text(
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
      );
}
