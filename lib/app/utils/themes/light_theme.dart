import 'package:erps/app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme(BuildContext context) => ThemeData(
      scaffoldBackgroundColor: bgColor,
      primaryColor: primaryColor,
      colorScheme:
          ColorScheme.fromSeed(seedColor: primaryColor, primary: primaryColor),
      textTheme: GoogleFonts.arimaTextTheme(Theme.of(context).textTheme)
          .apply(bodyColor: bodyColor),
      appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
          backgroundColor: Colors.white,
          foregroundColor: bodyColor,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryColor)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 12),
              minimumSize: const Size(120, 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: defaultPadding),
              foregroundColor: Colors.white,
              backgroundColor: primaryColor,
              disabledForegroundColor: Colors.black54.withOpacity(0.38),
              disabledBackgroundColor: Colors.black54.withOpacity(0.12),
              elevation: 3)),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        foregroundColor: const Color.fromRGBO(0, 0, 0, 1),
        minimumSize: const Size(88, 36),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 12),
              minimumSize: const Size(120, 50),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: defaultPadding),
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              disabledForegroundColor:
                  const Color.fromRGBO(105, 105, 105, 1).withOpacity(0.38),
              disabledBackgroundColor:
                  const Color.fromRGBO(220, 220, 220, 0.12),
              side: const BorderSide(width: 1, color: primaryColor),
              elevation: 3)),
      tabBarTheme: const TabBarTheme(
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
      ),

      // canvasColor: secondaryColor,
      // inputDecorationTheme: const InputDecorationTheme(
      //     floatingLabelStyle: TextStyle(fontSize: 18, color: secondaryColor),
      //     focusedBorder: OutlineInputBorder(
      //         borderSide: BorderSide(color: secondaryColor, width: 2)),
      //     border: OutlineInputBorder(borderSide: BorderSide())),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //         minimumSize: const Size(120, 50),
      //         padding: const EdgeInsets.symmetric(
      //             horizontal: 25, vertical: defaultPadding),
      //         foregroundColor: Colors.white,
      //         backgroundColor: primaryColor,
      //         disabledForegroundColor: Colors.black54.withOpacity(0.38),
      //         disabledBackgroundColor: Colors.black54.withOpacity(0.12),
      //         elevation: 3)),
      // outlinedButtonTheme: OutlinedButtonThemeData(
      //     style: OutlinedButton.styleFrom(
      //   minimumSize: const Size(120, 50),
      //   padding: const EdgeInsets.symmetric(
      //       horizontal: 25, vertical: defaultPadding),
      //   foregroundColor: Colors.black45,
      //   backgroundColor: Colors.white,
      //   disabledForegroundColor: Colors.black45.withOpacity(0.28),
      //   side: BorderSide(width: 1.5, color: Colors.black54.withOpacity(0.2)),
      // )),
      // textButtonTheme: TextButtonThemeData(
      //     style: TextButton.styleFrom(
      //   foregroundColor: Colors.black87,
      //   minimumSize: const Size(88, 36),
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.all(Radius.circular(2.0)),
      //   ),
      // )),
      // progressIndicatorTheme: const ProgressIndicatorThemeData(
      //     circularTrackColor: primaryColor, color: Colors.white),
      // checkboxTheme: CheckboxThemeData(
      //   side: MaterialStateBorderSide.resolveWith(
      //       (_) => const BorderSide(width: 1.2, color: primaryColor)),
      //   fillColor: MaterialStateProperty.all(primaryColor),
      //   checkColor: MaterialStateProperty.all(Colors.white),
      //   overlayColor: MaterialStateProperty.all(primaryColor.withOpacity(0.1)),
      // ),
    );
