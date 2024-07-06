import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  const Responsive({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  /// This size work fine on my design, maybe you need some customization depends on your design

  /// This isMobile, isTablet, isDesktop help us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 650;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
          MediaQuery.of(context).size.width >= 650;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  static Size size(BuildContext context) => MediaQuery.of(context).size;

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double horizontalPadding(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return Responsive.width(context) * 0.3;
    } else if (Responsive.isTablet(context)) {
      return Responsive.width(context) * 0.1;
    } else {
      return Responsive.width(context) * 0.1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 850 && constraints.maxWidth < 1100) {
        return tablet ?? const SizedBox();
      } else if (constraints.maxWidth >= 1100) {
        return desktop ?? const SizedBox();
      } else {
        return mobile ?? const SizedBox();
      }
    });

    // final Size size = Responsive.size(context);
    // // final Size size = MediaQuery.of(context).size;

    // /// If our width is more than 1100 then we consider it a desktop
    // if (size.width >= 1100) {
    //   return desktop;
    // }

    // /// If width it less then 1100 and more then 850 we consider it as tablet
    // else if (size.width >= 850 && tablet != null) {
    //   return tablet!;
    // }

    // /// Or less then that we called it mobile
    // else {
    //   return mobile;
    // }
  }
}
