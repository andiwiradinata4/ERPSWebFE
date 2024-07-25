import 'dart:developer';

import 'package:erps/core/config/responsive.dart';
import 'package:erps/core/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
    List<String> all = [];
    for (int i = 1; i < 101; i++) {
      (i == 100) ? all.add('Feature ERPS ABCD $i') : all.add('Feature $i');
    }
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
          children:
              all.map((e) => Center(child: FeatureCard(name: e))).toList(),
        ));
  }
}

class FeatureCard extends StatelessWidget {
  final String name;

  const FeatureCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
        onTap: () {
          log('Press $name');
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SvgPicture.asset(
                'lib/assets/svg/edit_primary.svg',
                width: 30,
              )),
              Text(
                name,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
