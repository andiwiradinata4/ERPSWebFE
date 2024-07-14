import 'package:erps/app/components/us_app_bar.dart';
import 'package:erps/app/components/us_dialog_builder.dart';
import 'package:erps/app/components/us_snackbar_builder.dart';
import 'package:erps/app/components/us_text_form_field.dart';
import 'package:erps/core/config/responsive.dart';
import 'package:erps/core/config/size_config.dart';
import 'package:erps/features/auth/presentation/bloc/v1/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Responsive.isMobile(context)
            ? usAppBar(
                context,
                title: 'Ubah Password',
              )
            : null,
        body: const Responsive(
          desktop: Default(),
          mobile: Default(),
        ));
  }
}

class Default extends StatefulWidget {
  const Default({super.key});

  @override
  State<Default> createState() => _DefaultState();
}

class _DefaultState extends State<Default> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
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
      _authBloc.add(ChangePasswordEvent(
          currentPassword: currentPasswordController.text.trim(),
          newPassword: passwordController.text.trim()));
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
        if (state is ChangePasswordSuccessState) {
          context.pop();
        } else if (state is LoginErrorState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showErrorSnackBar(context, state.message);
          });
        } else if (state is ChangePasswordErrorState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showErrorSnackBar(
                context, 'Gagal Ganti Password!');
          });
        }
      }),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: (Responsive.isMobile(context)) ? mobileView() : desktopView(),
        ),
      ),
    );
  }

  Row mobileView() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: SizeConfig.screenWidth * 0.9,
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
                        'Silahkan Masukan Password Lama dan Password Baru Anda',
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
                          fieldName: 'Password Lama',
                          usController: currentPasswordController,
                          textInputType: TextInputType.visiblePassword,
                          validateValue: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan Password Lama terlebih dahulu';
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

  Row desktopView() => Row(
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
                  'Ganti Password',
                  style: TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w600, height: 1.5),
                ),

                /// Spacer
                const SizedBox(
                  height: 18,
                ),

                /// Body Text
                const Text(
                  'Silahkan Masukan Password Lama dan Password Baru Anda',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500, height: 1.5),
                ),

                /// Spacer
                const SizedBox(
                  height: 18,
                ),

                /// Password Lama
                SizedBox(
                  width: SizeConfig.screenWidth * 0.3,
                  child: UsTextFormField(
                    fieldName: 'Password Lama',
                    usController: currentPasswordController,
                    textInputType: TextInputType.visiblePassword,
                    validateValue: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukan password lama terlebih dahulu';
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
