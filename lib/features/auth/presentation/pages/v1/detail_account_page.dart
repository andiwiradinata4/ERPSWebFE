import 'package:erps/app/components/us_dialog_builder.dart';
import 'package:erps/core/config/responsive.dart';
import 'package:erps/core/config/size_config.dart';
import 'package:erps/features/auth/presentation/bloc/v1/auth_bloc.dart';
import 'package:erps/routes/v1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class DetailAccountPage extends StatelessWidget {
  final String id;

  const DetailAccountPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Responsive(
      desktop: Desktop(id: id),
      tablet: Desktop(id: id),
      mobile: Desktop(id: id),
    );
  }
}

class Desktop extends StatefulWidget {
  final String id;

  const Desktop({super.key, required this.id});

  @override
  State<Desktop> createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  late AuthBloc authBloc;

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    super.initState();
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
      listener: (context, state) {},
      child: SizedBox(
        width: SizeConfig.screenWidth * 0.7,
        height: SizeConfig.screenHeight,
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            SizedBox(
              height: SizeConfig.screenHeight * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "Register User",
                          style: TextStyle(
                              fontSize:
                                  (Responsive.isDesktop(context)) ? 35 : 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 35,
                              padding: const EdgeInsets.only(left: 18),
                              child: ElevatedButton.icon(
                                label: const Text('Simpan'),
                                onPressed: () {},
                              ),
                            ),
                            Container(
                              height: 35,
                              padding: const EdgeInsets.only(left: 9),
                              child: OutlinedButton.icon(
                                label: Text(
                                  'Kembali',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                onPressed: () =>
                                    context.goNamed(routeNameListAccountPage),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const Center(child: Text('Detail Account Page')),
          ],
        )),
      ),
    );
  }
}
