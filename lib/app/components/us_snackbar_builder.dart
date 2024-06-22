import 'package:erps/app/utils/config.dart';
import 'package:flutter/material.dart';

class UsSnackBarBuilder {
  static showErrorSnackBar(BuildContext context, String content) => show(
      context: context,
      content: content,
      backgroundColor: bgError,
      labelAction: "",
      textColor: Colors.white,
      showCloseIcon: true,
      onPressed: () => Navigator.of(context).pop);

  static showSuccessSnackBar(BuildContext context, String content) => show(
      context: context,
      content: content,
      backgroundColor: bgSuccess,
      labelAction: "",
      textColor: Colors.white,
      showCloseIcon: true,
      onPressed: () => Navigator.of(context).pop);

  static show(
      {required BuildContext context,
        required String content,
        required Color backgroundColor,
        required String labelAction,
        required Color textColor,
        required bool showCloseIcon,
        required Function() onPressed}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: labelAction,
          onPressed: onPressed,
          textColor: textColor,
        ),
        content: Text(
          content,
          style: TextStyle(color: textColor),
        ),
        duration: const Duration(milliseconds: 1500),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        showCloseIcon: showCloseIcon,
        closeIconColor: textColor,
      ),
    );
  }
}
