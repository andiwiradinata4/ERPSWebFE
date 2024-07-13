import 'package:erps/app/auth/cubit/auth_cubit.dart';
import 'package:erps/app/utils/config.dart';
import 'package:erps/core/config/responsive.dart';
import 'package:erps/core/config/size_config.dart';
import 'package:erps/features/auth/presentation/bloc/v1/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class Desktop extends StatelessWidget {
  const Desktop({super.key});

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = context.read<AuthCubit>();
    return BlocBuilder<AuthCubit, AuthAppState>(
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
                          height: 35,
                          child: ElevatedButton(
                              onPressed: () {}, child: const Text('Edit')),
                        )
                      ],
                    ),
                  ),

                  /// Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1)),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  Text(
                    '${state.user.firstName} ${state.user.lastName}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: [
                      Text(
                        state.user.email,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      (state.user.emailConfirmed)
                          ? TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Verifikasi Sekarang ?',
                                style: TextStyle(
                                    color: bgError,
                                    fontWeight: FontWeight.w600),
                              ))
                          : const Text(
                              'Terverifikasi',
                              style: TextStyle(color: bgSuccess),
                            ),
                    ],
                  )
                ],
              ),
            );
          } else {
            return const Center(
                child: Text('Anda tidak memiliki Akses di halaman ini!'));
          }
        });
  }
}
