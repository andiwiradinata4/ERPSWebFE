import 'package:erps/app/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/constants.dart';
import '../../core/config/injector_dependency_name.dart';
import '../../features/auth/domain/services/v1/abs_auth_service.dart';

class LinkSideBar {
  late String icon, label, link;
  late Function() onPressed;
  late List<LinkSideBar>? children;
  late bool isSelected = false;
  late bool isExpanded = false;

  LinkSideBar(
      {required this.icon,
      required this.label,
      required this.link,
      required this.onPressed,
      this.children,
      this.isSelected = false,
      this.isExpanded = false});
}

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  late AnimationController expandedController;
  late Animation<double> animation;

  late LinkSideBar selectedItem;
  late List<LinkSideBar> items;
  final ScrollController verticalController = ScrollController();

  @override
  void initState() {
    super.initState();
    items = [
      LinkSideBar(
          icon: 'lib/assets/svg/home',
          label: 'Home',
          link: 'home',
          onPressed: () {}),
      // LinkSideBar(
      //     icon: 'lib/assets/svg/master.svg',
      //     label: 'Master',
      //     link: '',
      //     onPressed: () {},
      //     children: [
      //       // LinkSideBar(
      //       //     icon: '',
      //       //     label: 'Access',
      //       //     link: routeNameMasterAccessPage,
      //       //     onPressed: () {}),
      //       // LinkSideBar(
      //       //     icon: '',
      //       //     label: 'Program',
      //       //     link: routeNameMasterProgramPage,
      //       //     onPressed: () {}),
      //       LinkSideBar(
      //           icon: '', label: 'Module', link: 'module', onPressed: () {}),
      //     ]),
      // LinkSideBar(
      //     icon: 'lib/assets/svg/transaction.svg',
      //     label: 'Transaksi',
      //     link: '',
      //     onPressed: () {}),
      // LinkSideBar(
      //     icon: 'lib/assets/svg/report.svg',
      //     label: 'Laporan',
      //     link: '',
      //     onPressed: () {}),
      LinkSideBar(
          icon: 'lib/assets/svg/account',
          label: 'Akun Saya',
          link: 'my-account',
          onPressed: () {}),
      LinkSideBar(
          icon: 'lib/assets/svg/logout',
          label: 'Keluar',
          link: 'login',
          onPressed: () {
            final authCubit = context.read<AuthCubit>();
            final authService = GetIt.I.get<AbsAuthService>(
                instanceName: InjectorDependencyName.authService);
            authService.deleteToken();
            authCubit.setAsAnonymous();
          }),
    ];
    selectedItem = items.first;

    // items += items + items;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: verticalController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 10),
        controller: verticalController,
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(defaultPadding),
                  height: 150,
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    "Logo Software",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
              //   child: Image.asset(
              //     "assets/images/logotext.jpg",
              //     fit: BoxFit.cover,
              //   ),
              // ),
              Column(
                children: items.map((e) => sideMenu(e)).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget sideMenu(LinkSideBar item) {
    return (item.children == null)
        ? sideMenuBody(item: item)
        : sideMenuExpanding(item: item);
  }

  Widget sideMenuExpanding({required LinkSideBar item}) => ExpansionPanelList(
        elevation: 0,
        dividerColor: Colors.grey.withOpacity(0.3),
        expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 0),
        animationDuration: const Duration(milliseconds: 500),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            item.isExpanded = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: item.isExpanded,
              headerBuilder: ((context, isExpanded) =>
                  sideMenuBody(item: item, isExpanding: true)),
              body: Column(
                children: item.children!
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(left: defaultPadding),
                          child: sideMenuBody(item: e, isExpanding: false),
                        ))
                    .toList(),
              ))
        ],
      );

  Widget sideMenuBody({required LinkSideBar item, bool isExpanding = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: (isExpanding)
              ? null
              : () {
                  if (mounted) {
                    setState(() {
                      selectedItem = item;
                    });
                  }
                  item.onPressed();
                  context.goNamed(item.link);
                },
          splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
          child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: defaultPadding, horizontal: defaultPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (item == selectedItem)
                  ? Theme.of(context).primaryColor.withOpacity(0.8)
                  : Colors.white30,
            ),
            child: Row(
              children: [
                /// Sidebar image / icon
                (item.icon != '')
                    ? (item == selectedItem)
                        ? SvgPicture.asset('${item.icon}_white.svg',
                            width: 30,
                            height: 30,
                            semanticsLabel: item.label)
                        : SvgPicture.asset('${item.icon}_primary.svg',
                            width: 30,
                            height: 30,
                            semanticsLabel: item.label)
                    : const SizedBox(
                        width: 30,
                      ),

                /// Spacer
                (item.icon != '')
                    ? const SizedBox(width: defaultPadding)
                    : const SizedBox(),

                /// Label / Name of Sidebar Button
                Expanded(
                    child: Text(
                  item.label,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: (item == selectedItem)
                          ? Colors.white
                          : Theme.of(context).primaryColor),
                )),
              ],
            ),
          ),
        ),
      );
}
