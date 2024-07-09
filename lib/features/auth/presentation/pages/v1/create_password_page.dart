import 'package:erps/app/components/us_app_bar.dart';
import 'package:erps/app/components/us_text_form_field.dart';
import 'package:erps/core/config/responsive.dart';
import 'package:erps/core/config/size_config.dart';
import 'package:erps/features/auth/presentation/bloc/v1/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              title: 'Verifikasi',
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
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
  }

  void fVerify() {
    if (formKey.currentState!.validate()) {
      // if (widget.code != codeController.text.trim()) {
      //   Future.delayed(Duration.zero, () {
      //     UsSnackBarBuilder.showErrorSnackBar(
      //         context, 'Kode verifikasi tidak valid!');
      //   });
      //   return;
      // }

      // if (widget.process == "RESET_PASSWORD") {
      //   context.pushNamed('create-password-page', extra: {
      //     'references': widget.references,
      //     'accessToken': widget.accessToken,
      //     'code': widget.code
      //   });
      // }
    }
  }

  void fBack() => context.pop();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: (Responsive.isMobile(context))
            ? mobileView(widget.references)
            : desktopView(widget.references),
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
                        child:

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
                    usController: passwordController,
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
