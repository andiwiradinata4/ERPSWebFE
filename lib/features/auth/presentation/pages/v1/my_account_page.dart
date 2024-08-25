import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/auth/cubit/auth_cubit.dart';
import '../../../../../app/components/us_dialog_builder.dart';
import '../../../../../core/config/constants.dart';
import '../../../../../core/config/responsive.dart';
import '../../../../../core/config/size_config.dart';
import '../../../../../routes/v1.dart';
import '../../bloc/v1/auth_bloc.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Responsive(
      desktop: Desktop(),
      mobile: Desktop(),
    );
  }
}

class Desktop extends StatefulWidget {
  const Desktop({super.key});

  @override
  State<Desktop> createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  late AuthCubit authCubit;
  late AuthBloc authBloc;
  String references = '';

  @override
  void initState() {
    authCubit = context.read<AuthCubit>();
    authBloc = context.read<AuthBloc>();
    super.initState();
  }

  void resetPassword(String email) {
    references = email;
    authBloc.add(ForgetPasswordTokenEvent(email: email));
  }

  void changePassword() {
    context.pushNamed(routeNameChangePasswordPage);
  }

  void emailConfirmationTokenEvent() =>
      authBloc.add(EmailConfirmationTokenEvent());

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previousState, state) {
        if (previousState is LoginLoadingState) {
          UsDialogBuilder.dispose();
        }
        return true;
      },
      listener: (context, state) {
        if (state is LoginLoadingState) {
          Future.delayed(
              Duration.zero, () => UsDialogBuilder.loadLoadingDialog(context));
        } else if (state is ForgetPasswordTokenState) {
          log("${state.token.accessToken} - ${state.token.code}");
          Future.delayed(
              Duration.zero,
              () => context.pushNamed(routeNameVerifyTokenPage, extra: {
                    'process': 'RESET_PASSWORD',
                    'references': references,
                    'accessToken': state.token.accessToken,
                    'code': state.token.code
                  }));
        } else if (state is EmailConfirmationTokenState) {
          log("${state.token.accessToken} - ${state.token.code}");
          Future.delayed(
              Duration.zero,
              () => context.pushNamed(routeNameVerifyTokenPage, extra: {
                    'process': 'VERIFY_EMAIL_ADDRESS',
                    'references': references,
                    'accessToken': state.token.accessToken,
                    'code': state.token.code
                  }));
        } else if (state is VerifyEmailSuccessState) {
          setState(() {
            authCubit.setAsAuthenticated(state.user);
          });
        }
      },
      child: BlocBuilder<AuthCubit, AuthAppState>(
          bloc: authCubit,
          builder: (context, state) {
            if (state is Authenticated) {
              return Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenHeight,
                color: Theme.of(context).primaryColor.withOpacity(0.03),
                padding: const EdgeInsets.only(left: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Container(
                      height: 150,
                      padding: const EdgeInsets.only(top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Informasi Personal',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          SizedBox(
                            height: 38,
                            child: ElevatedButton.icon(
                              icon: SvgPicture.asset(
                                  'lib/assets/svg/edit_white.svg'),
                              label: const Text('Edit', style: TextStyle(fontSize: 15)),
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                    ),

                    /// Image
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.4),
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: SvgPicture.asset('lib/assets/svg/profile.svg',
                            fit: BoxFit.cover, width: 1, height: 1),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    Text(
                      '${state.user.firstName} ${state.user.lastName}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    Fields(
                      fieldName: 'Username',
                      fieldValue: state.user.userName,
                    ),

                    Fields(
                      fieldName: 'Email',
                      fieldValue: state.user.email,
                      widgetValue: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.user.email,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                (!state.user.emailConfirmed)
                                    ? SizedBox(
                                        height: 18,
                                        child: TextButton(
                                            onPressed:
                                                emailConfirmationTokenEvent,
                                            child: const Text(
                                              'Verifikasi Sekarang',
                                              style: TextStyle(
                                                  color: bgError,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                              'lib/assets/svg/verified_success.svg'),
                                          const Text(
                                            'Terverifikasi',
                                            style: TextStyle(color: bgSuccess),
                                          ),
                                          SizedBox(
                                            height: 18,
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                      'lib/assets/svg/edit_primary.svg'),
                                                  Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    Fields(
                      fieldName: 'Nomor Telepon',
                      fieldValue: state.user.phoneNumber,
                      widgetValue: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.user.phoneNumber,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                (!state.user.phoneNumberConfirmed)
                                    ? SizedBox(
                                        height: 18,
                                        child: TextButton(
                                            onPressed: () {},
                                            child: const Text(
                                              'Verifikasi Sekarang',
                                              style: TextStyle(
                                                  color: bgError,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                              'lib/assets/svg/verified_success.svg'),
                                          const Text(
                                            'Terverifikasi',
                                            style: TextStyle(color: bgSuccess),
                                          ),
                                          SizedBox(
                                            height: 18,
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                      'lib/assets/svg/edit_primary.svg'),
                                                  Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    SizedBox(
                      height: 35,
                      child: Row(
                        children: [
                          /// Reset Password
                          ElevatedButton.icon(
                            icon: SvgPicture.asset(
                                'lib/assets/svg/setting_white.svg'),
                            label: const Text('Reset Password'),
                            onPressed: () => resetPassword(state.user.email),
                          ),

                          const SizedBox(
                            width: 18,
                          ),

                          /// Change Password
                          ElevatedButton.icon(
                            icon: SvgPicture.asset(
                                'lib/assets/svg/edit_white.svg'),
                            label: const Text('Ganti Password'),
                            onPressed: changePassword,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                  child: Text('Anda tidak memiliki Akses di halaman ini!'));
            }
          }),
    );
  }
}

class Fields extends StatelessWidget {
  final String fieldName, fieldValue;
  final Widget? widgetValue;

  const Fields(
      {super.key,
      required this.fieldName,
      required this.fieldValue,
      this.widgetValue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Label
          SizedBox(
            width: 150,
            child: Text(
              fieldName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(
            width: 18,
          ),

          const SizedBox(
            child: Text(":"),
          ),

          const SizedBox(
            width: 18,
          ),

          /// Field Value
          (widgetValue) ??
              SizedBox(
                child: Text(
                  fieldValue,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
        ],
      ),
    );
  }
}
