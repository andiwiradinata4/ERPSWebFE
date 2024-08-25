import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/auth/cubit/auth_cubit.dart';
import '../../../../../app/components/us_app_bar.dart';
import '../../../../../app/components/us_dialog_builder.dart';
import '../../../../../app/components/us_snack_bar_builder.dart';
import '../../../../../app/components/us_text_form_field.dart';
import '../../../../../core/config/responsive.dart';
import '../../../../../core/config/size_config.dart';
import '../../../../../routes/v1.dart';
import '../../../domain/entities/v1/verify_email_confirmation_entity.dart';
import '../../bloc/v1/auth_bloc.dart';

/// PROCESS : RESET_PASSWORD | CHANGE_PASSWORD | CHANGE_PHONE_NUMBER / VERIFY_EMAIL_ADDRESS / VERIFY_PHONE_NUMBER

class VerifyTokenPage extends StatelessWidget {
  final String process;
  final String references;
  final String accessToken;
  final String code;

  const VerifyTokenPage(
      {super.key,
      required this.process,
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
              title: 'Verifikasi',
            )
          : null,
      body: Responsive(
        desktop: Default(
            process: process,
            references: references,
            accessToken: accessToken,
            code: code),
        mobile: Default(
            process: process,
            references: references,
            accessToken: accessToken,
            code: code),
        tablet: Default(
            process: process,
            references: references,
            accessToken: accessToken,
            code: code),
      ),
    );
  }
}

class Default extends StatefulWidget {
  final String process;
  final String references;
  final String accessToken;
  final String code;

  const Default(
      {super.key,
      required this.process,
      required this.references,
      required this.accessToken,
      required this.code});

  @override
  State<Default> createState() => _DefaultState();
}

class _DefaultState extends State<Default> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController codeController = TextEditingController();
  late AuthBloc _authBloc;

  @override
  void initState() {
    /// Get Auth Bloc
    _authBloc = context.read<AuthBloc>();

    super.initState();
  }

  void fVerify() {
    if (formKey.currentState!.validate()) {
      if (widget.code != codeController.text.trim()) {
        Future.delayed(Duration.zero, () {
          UsSnackBarBuilder.showErrorSnackBar(
              context, 'Kode verifikasi tidak valid!');
        });
        return;
      }

      if (widget.process == "RESET_PASSWORD") {
        // context.goNamed(routeNameCreatePasswordPage, extra: {
        //   'references': widget.references,
        //   'accessToken': widget.accessToken,
        //   'code': widget.code
        // });
        context.pushNamed(routeNameCreatePasswordPage, extra: {
          'references': widget.references,
          'accessToken': widget.accessToken,
          'code': widget.code
        });
      } else if (widget.process == "VERIFY_EMAIL_ADDRESS") {
        _authBloc.add(VerifyEmailConfirmationEvent(
            data: VerifyEmailConfirmationEntity(
                accessToken: widget.accessToken, code: widget.code)));
      }
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
        if (state is VerifyEmailSuccessState) {
          setState(() {
            AuthCubit().setAsAuthenticated(state.user);
            context.pop();
          });
        } else if (state is LoginErrorState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showErrorSnackBar(context, state.message);
          });
        } else if (state is VerifyEmailErrorState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showErrorSnackBar(
                context, 'Gagal Verifikasi Email!');
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
                      /// Body
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text:
                              'Masukan kode verifikasi yang telah dikirim ke ',
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontSize: 16, height: 1.5),
                          children: [
                            TextSpan(
                                text: references,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                      /// Spacer
                      const SizedBox(
                        height: 25,
                      ),

                      /// Code
                      SizedBox(
                        child: UsTextFormField(
                          fieldName: 'Kode Verifikasi',
                          usController: codeController,
                          textInputType: TextInputType.number,
                          validateValue: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan kode verifikasi terlebih dahulu';
                            }

                            return null;
                          },
                        ),
                      ),

                      /// Spacer
                      const SizedBox(
                        height: 15,
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
                  'Verifikasi',
                  style: TextStyle(
                      fontSize: 40, fontWeight: FontWeight.w600, height: 1.5),
                ),

                /// Spacer
                const SizedBox(
                  height: 30,
                ),

                /// Body
                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: 'Masukan kode verifikasi yang telah dikirim ke ',
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 20, height: 1.5),
                    children: [
                      TextSpan(
                          text: references,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                /// Spacer
                const SizedBox(
                  height: 18,
                ),

                /// Code
                SizedBox(
                  width: SizeConfig.screenWidth * 0.3,
                  child: UsTextFormField(
                    fieldName: 'Kode Verifikasi',
                    usController: codeController,
                    textInputType: TextInputType.number,
                    validateValue: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukan kode verifikasi terlebih dahulu';
                      }

                      return null;
                    },
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
