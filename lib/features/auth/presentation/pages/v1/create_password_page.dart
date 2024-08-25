import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/auth/cubit/auth_cubit.dart';
import '../../../../../app/components/us_app_bar.dart';
import '../../../../../app/components/us_dialog_builder.dart';
import '../../../../../app/components/us_snack_bar_builder.dart';
import '../../../../../app/components/us_text_form_field.dart';
import '../../../../../core/config/injector_dependency_name.dart';
import '../../../../../core/config/responsive.dart';
import '../../../../../core/config/size_config.dart';
import '../../../../../routes/v1.dart';
import '../../../domain/entities/v1/reset_password_entity.dart';
import '../../../domain/services/v1/abs_auth_service.dart';
import '../../bloc/v1/auth_bloc.dart';

class CreatePasswordPage extends StatelessWidget {
  final String references;
  final String accessToken;
  final String code;

  const CreatePasswordPage(
      {super.key,
      required this.references,
      required this.accessToken,
      required this.code});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? usAppBar(
              context,
              title: 'Buat Password Baru',
            )
          : null,
      body: Responsive(
        desktop: Default(
            references: references, accessToken: accessToken, code: code),
        mobile: Default(
            references: references, accessToken: accessToken, code: code),
        tablet: Default(
            references: references, accessToken: accessToken, code: code),
      ),
    );
  }
}

class Default extends StatefulWidget {
  final String references;
  final String accessToken;
  final String code;

  const Default(
      {super.key,
      required this.references,
      required this.accessToken,
      required this.code});

  @override
  State<Default> createState() => _DefaultState();
}

class _DefaultState extends State<Default> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  late AuthBloc _authBloc;

  @override
  void initState() {
    /// Get Auth Bloc
    _authBloc = context.read<AuthBloc>();

    super.initState();
  }

  void fVerify() {
    if (formKey.currentState!.validate()) {
      _authBloc.add(ResetPasswordEvent(
          data: ResetPasswordEntity(
              email: widget.references,
              newPassword: passwordController.text.trim(),
              token: widget.accessToken,
              code: widget.code)));
    }
  }

  void fBack() => context.pop();

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
        if (state is ResetPasswordSuccessState) {
          final authCubit = context.read<AuthCubit>();
          final authService = GetIt.I.get<AbsAuthService>(
              instanceName: InjectorDependencyName.authService);
          authService.deleteToken();
          authCubit.setAsAnonymous();

          Future.delayed(
              Duration.zero, () => context.goNamed(routeNameHomePage));
        } else if (state is ResetPasswordErrorState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showErrorSnackBar(
                context, 'Gagal Buat Password Baru!');
          });
        }
      }),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: (Responsive.isMobile(context))
              ? mobileView(widget.references)
              : desktopView(widget.references),
        ),
      ),
    );
  }

  Row mobileView(String references) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.1),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Spacer
                      const SizedBox(
                        height: 15,
                      ),

                      /// Header Text
                      const Text(
                        'Silahkan Buat Password Baru Anda',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5),
                      ),

                      /// Spacer
                      const SizedBox(
                        height: 18,
                      ),

                      /// Password
                      SizedBox(
                        child: UsTextFormField(
                          fieldName: 'Password Baru',
                          usController: passwordController,
                          textInputType: TextInputType.visiblePassword,
                          validateValue: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan Password Baru terlebih dahulu';
                            }
                            if (value.trim() !=
                                confirmPasswordController.text.trim()) {
                              return 'Password Baru dan Konfirmasi Password Baru tidak sama!';
                            }
                            return null;
                          },
                          useSuffixIcon: true,
                          activeSuffixIcon: Icons.visibility_outlined,
                          deActiveSuffixIcon: Icons.visibility_off_outlined,
                          isPasswordHandle: true,
                        ),
                      ),

                      /// Spacer
                      const SizedBox(
                        height: 25,
                      ),

                      /// Confirm Password
                      SizedBox(
                        child: UsTextFormField(
                          fieldName: 'Konfirmasi Password Baru',
                          usController: confirmPasswordController,
                          textInputType: TextInputType.visiblePassword,
                          validateValue: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan kofirmasi Password Baru terlebih dahulu';
                            }

                            if (value.trim() !=
                                passwordController.text.trim()) {
                              return 'Password Baru dan Konfirmasi Password Baru tidak sama!';
                            }

                            return null;
                          },
                          useSuffixIcon: true,
                          activeSuffixIcon: Icons.visibility_outlined,
                          deActiveSuffixIcon: Icons.visibility_off_outlined,
                          isPasswordHandle: true,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight * 0.8),
                    child: Column(
                      children: [
                        /// Next Button
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: SizeConfig.screenWidth,
                            child: ElevatedButton(
                                onPressed: fVerify,
                                child: const Text(
                                  'Lanjut',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                )),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: SizeConfig.screenWidth,
                            child: OutlinedButton(
                                onPressed: fBack,
                                child: const Text(
                                  'Kembali',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                )),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );

  Row desktopView(String references) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            alignment: Alignment.center,
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Spacer
                SizedBox(
                  height: SizeConfig.screenHeight * 0.2,
                ),

                /// Header Text
                const Text(
                  'Buat Password Baru',
                  style: TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w600, height: 1.5),
                ),

                /// Spacer
                const SizedBox(
                  height: 18,
                ),

                /// Body Text
                const Text(
                  'Silahkan Buat Password Baru Anda',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500, height: 1.5),
                ),

                /// Spacer
                const SizedBox(
                  height: 18,
                ),

                /// Password
                SizedBox(
                  width: SizeConfig.screenWidth * 0.3,
                  child: UsTextFormField(
                    fieldName: 'Password Baru',
                    usController: passwordController,
                    textInputType: TextInputType.visiblePassword,
                    validateValue: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukan password baru terlebih dahulu';
                      }
                      if (value.trim() !=
                          confirmPasswordController.text.trim()) {
                        return 'Password Baru dan Konfirmasi Password tidak sama!';
                      }
                      return null;
                    },
                    useSuffixIcon: true,
                    activeSuffixIcon: Icons.visibility_outlined,
                    deActiveSuffixIcon: Icons.visibility_off_outlined,
                    isPasswordHandle: true,
                  ),
                ),

                /// Spacer
                const SizedBox(
                  height: 18,
                ),

                /// Confirm Password
                SizedBox(
                  width: SizeConfig.screenWidth * 0.3,
                  child: UsTextFormField(
                    fieldName: 'Konfirmasi Password Baru',
                    usController: confirmPasswordController,
                    textInputType: TextInputType.visiblePassword,
                    validateValue: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukan Konfirmasi Password Baru terlebih dahulu';
                      }

                      if (value.trim() != passwordController.text.trim()) {
                        return 'Password Baru dan Konfirmasi Password Baru tidak sama!';
                      }

                      return null;
                    },
                    useSuffixIcon: true,
                    activeSuffixIcon: Icons.visibility_outlined,
                    deActiveSuffixIcon: Icons.visibility_off_outlined,
                    isPasswordHandle: true,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                SizedBox(
                  width: SizeConfig.screenWidth * 0.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /// Next Button
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.14,
                        child: ElevatedButton(
                            onPressed: fVerify,
                            child: const Text(
                              'Lanjut',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                            )),
                      ),

                      /// Spacer
                      SizedBox(
                        width: SizeConfig.screenWidth * 0.02,
                      ),

                      SizedBox(
                        width: SizeConfig.screenWidth * 0.14,
                        child: OutlinedButton(
                            onPressed: fBack,
                            child: const Text(
                              'Kembali',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
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
      );
}
