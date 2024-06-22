// ignore_for_file: must_be_immutable

import 'package:erps/app/utils/config.dart';
import 'package:erps/core/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

mixin IDialogService {
  void dismiss();
}

abstract class IDialog extends StatelessWidget with IDialogService {
  const IDialog({super.key});
}

class UsDialogBuilder {
  const UsDialogBuilder._();

  static IDialog? _current;

  static Future<void> loadErrorDialog(BuildContext context,
      {required String message,
        bool repeat = true,
        bool showButton = true}) async {
    _current = LoadDialog(
      title: '',
      asset: 'lib/assets/lottie/error.json',
      message: message,
      repeat: repeat,
      showButton: showButton,
      width: 200,
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
      _current ??
          LoadDialog(
            title: '',
            asset: 'lib/assets/lottie/error.json',
            message: message,
            repeat: repeat,
            showButton: showButton,
            width: 200,
          ),
    );
  }

  static Future<void> loadSuccessDialog(BuildContext context,
      {required String message,
        bool repeat = true,
        bool showButton = true}) async {
    _current = LoadDialog(
      title: '',
      asset: 'lib/assets/lottie/success.json',
      message: message,
      repeat: repeat,
      showButton: showButton,
      width: 200,
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
      _current ??
          LoadDialog(
            title: '',
            asset: 'lib/assets/lottie/success.json',
            message: message,
            repeat: repeat,
            showButton: showButton,
            width: 200,
          ),
    );
  }

  static Future<void> loadAlertDialog(BuildContext context,
      {String title = "",
        required String asset,
        required String message,
        bool repeat = true,
        bool showButton = true}) async {
    _current = LoadDialog(
      title: title,
      asset: asset,
      message: message,
      repeat: repeat,
      showButton: showButton,
      width: 200,
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
      _current ??
          LoadDialog(
            title: title,
            asset: asset,
            message: message,
            repeat: repeat,
            showButton: showButton,
            width: 200,
          ),
    );
  }

  static Future<void> loadLoadingDialog(
      BuildContext context,
      ) async {
    _current = LoadDialog(
      title: '',
      asset: 'lib/assets/lottie/loading.json',
      message: 'Loading ... ',
      repeat: true,
      showButton: false,
      width: 100,
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
      _current ??
          LoadDialog(
            title: '',
            asset: 'lib/assets/lottie/loading.json',
            message: 'Loading ... ',
            repeat: true,
            showButton: false,
            width: 100,
          ),
    );
  }

  static void dispose() {
    if (_current != null) {
      _current!.dismiss();
      _current = null;
    }
  }
}

class LoadDialog extends IDialog {
  final String title, asset, message;
  final bool repeat, showButton;
  final double width;

  LoadDialog(
      {super.key,
        required this.title,
        required this.asset,
        required this.message,
        required this.repeat,
        required this.showButton,
        required this.width});

  BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return AlertDialog(
      scrollable: true,
      title: Text(title),
      content: Container(
        alignment: Alignment.center,
        // constraints: const BoxConstraints(maxHeight: 250, maxWidth: 500),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset(asset, repeat: repeat, width: width),
              const SizedBox(height: defaultPadding),
              Text(message),
              const SizedBox(height: defaultPadding),
              (showButton)
                  ? SizedBox(
                width: SizeConfig.screenWidth,
                child: OutlinedButton(
                  onPressed: () => dismiss(),
                  child: const Text('OK'),
                ),
              )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dismiss() {
    Navigator.pop(_context!);
  }
}
