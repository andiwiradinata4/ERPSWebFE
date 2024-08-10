import 'package:erps/core/config/responsive.dart';
import 'package:erps/core/config/size_config.dart';
import 'package:erps/features/home/data/models/menu.dart';
import 'package:erps/routes/v1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Responsive(
      desktop: Desktop(),
      mobile: Desktop(),
      tablet: Desktop()      
    );
  }
}

class Desktop extends StatelessWidget {
  const Desktop({super.key});

  @override
  Widget build(BuildContext context) {
    List<Menu> all = [];
    all.add(const Menu(
        id: 1,
        name: 'User',
        route: routeNameListAccountPage,
        iconName: 'account_primary'));
    return Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 8,
          children: all
              .map((e) => Center(
                      child: FeatureCard(
                    data: e,
                  )))
              .toList(),
        ));
  }
}

class FeatureCard extends StatelessWidget {
  final Menu data;

  const FeatureCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
        onTap: () => context.goNamed(data.route),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8,) ,
              Expanded(
                  child: SvgPicture.asset(
                'lib/assets/svg/${data.iconName}.svg',
                width: 70,
              )),
              const SizedBox(height: 8,),
              Text(
                data.name,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
