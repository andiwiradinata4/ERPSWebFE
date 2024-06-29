import 'dart:developer';

import 'package:erps/app/components/us_dialog_builder.dart';
import 'package:erps/app/components/us_snackbar_builder.dart';
import 'package:erps/app/components/us_text_form_field.dart';
import 'package:erps/core/config/responsive.dart';
import 'package:erps/core/config/size_config.dart';
import 'package:erps/features/auth/presentation/bloc/v1/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      // appBar: AppBar(),
      body: Responsive(
        desktop: Desktop(),
        mobile: Mobile(),
        tablet: Desktop(),
      ),
    );
  }
}

class Desktop extends StatefulWidget {
  const Desktop({super.key});

  @override
  State<Desktop> createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();

    /// Get Auth Bloc
    _authBloc = context.read<AuthBloc>();
  }

  void fForgetPasswordToken() {
    if (formKey.currentState!.validate()) {
      _authBloc
          .add(ForgetPasswordTokenEvent(email: emailController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
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
          } else if (state is ForgetPasswordTokenState) {
            log("${state.token.accessToken} - ${state.token.code}" );
          } else if (state is SuccessGetDetailState) {
            // _authCubit.setAsAuthenticated(state.user);
            // if (widget.redirectTo.isNotEmpty) {
            //   GoRouter.of(context).pushReplacement(widget.redirectTo);
            // } else {
            //   GoRouter.of(context).pushReplacementNamed('home');
            // }
          }
        }),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: SizeConfig.screenWidth * 0.8,
                  height: SizeConfig.screenHeight,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Spacer
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.2,
                      ),

                      /// Header Text
                      const Text(
                        'Lupa Password',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            height: 1.5),
                      ),

                      /// Welcome Text
                      const Text(
                        'Silahkan Masukkan Email Anda',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.5),
                      ),

                      /// Spacer
                      const SizedBox(
                        height: 50,
                      ),

                      /// Email
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.4,
                        child: UsTextFormField(
                          fieldName: 'Email',
                          usController: emailController,
                          textInputType: TextInputType.emailAddress,
                          validateValue: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan email terlebih dahulu';
                            }

                            return null;
                          },
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      SizedBox(
                        width: SizeConfig.screenWidth * 0.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            /// Next Button
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.19,
                              child: ElevatedButton(
                                  onPressed: fForgetPasswordToken,
                                  child: const Text(
                                    'Lanjut',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800),
                                  )),
                            ),

                            /// Spacer
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.02,
                            ),

                            SizedBox(
                              width: SizeConfig.screenWidth * 0.19,
                              child: OutlinedButton(
                                  onPressed: () =>
                                      GoRouter.of(context).go('/login'),
                                  child: const Text(
                                    'Kembali',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800),
                                  )),
                            )
                          ],
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
  const Mobile({super.key});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  late AuthBloc _loginBloc;

  @override
  void initState() {
    super.initState();

    /// Get Login Bloc
    _loginBloc = context.read<AuthBloc>();
  }

  void fLogin() {
    if (formKey.currentState!.validate()) {
      _loginBloc
          .add(ForgetPasswordTokenEvent(email: emailController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
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
            // _authCubit.setAsAuthenticated(state.user);
            // if (widget.redirectTo.isNotEmpty) {
            //   GoRouter.of(context).pushReplacement(widget.redirectTo);
            // } else {
            //   GoRouter.of(context).pushReplacementNamed('home');
            // }
          }
        }),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: SizeConfig.screenWidth * 0.9,
                  height: SizeConfig.screenHeight * 0.9,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Spacer
                      const SizedBox(
                        height: 10,
                      ),

                      /// Header Text
                      const Text(
                        'Lupa Password',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            height: 1.5),
                      ),

                      /// Welcome Text
                      const Text(
                        'Silahkan Masukkan Email Anda',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.5),
                      ),

                      /// Spacer
                      const SizedBox(
                        height: 18,
                      ),

                      /// Email
                      UsTextFormField(
                        fieldName: 'Email',
                        usController: emailController,
                        textInputType: TextInputType.emailAddress,
                        validateValue: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan email terlebih dahulu';
                          }

                          return null;
                        },
                      ),

                      /// Spacer
                      const SizedBox(
                        height: 15,
                      ),

                      /// Next Button
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

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: SizeConfig.screenWidth,
                          child: OutlinedButton(
                              onPressed: () =>
                                  GoRouter.of(context).go('/login'),
                              child: const Text(
                                'Kembali',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w800),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
