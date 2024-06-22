import 'package:erps/app/components/sidebar.dart';
import 'package:flutter/material.dart';

class WrapperWidget {
  final Widget? child;
  final bool sidebar;

  WrapperWidget({required this.child, this.sidebar = true});
}

class Wrapper extends StatelessWidget {
  final ScrollController verticalController;
  final WrapperWidget? child;

  const Wrapper({super.key, required this.verticalController, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(60),
        //   child: AppBar(
        //     backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        //     title: BlocBuilder(
        //         bloc: context.read<AuthCubit>(),
        //         builder: (context, state) {
        //           String name = "-";
        //           if (state is Authenticated) {
        //             name = '${state.user.firstName} ${state.user.lastName}';
        //           }
        //           return Container(
        //               padding: const EdgeInsets.only(left: 8),
        //               child: RichText(
        //                   text: TextSpan(
        //                       text: 'Welcome Back,\n',
        //                       style: const TextStyle(
        //                           color: Colors.white, height: 1.2),
        //                       children: [
        //                     TextSpan(
        //                         text: name,
        //                         style: const TextStyle(
        //                             fontWeight: FontWeight.bold, fontSize: 20))
        //                   ])));
        //         }),
        //   ),
        // ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              controller: verticalController,
              child: SingleChildScrollView(
                controller: verticalController,
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SideBar(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: SingleChildScrollView(
                            child: (child != null)
                                ? child!.child ?? Container()
                                : Container(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
