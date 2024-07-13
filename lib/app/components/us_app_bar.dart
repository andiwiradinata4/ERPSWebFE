import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

AppBar usAppBar(BuildContext context, {required String title}) {
  return AppBar(
    leading: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded)),
    title: Text(
      title,
      maxLines: 1,
      style:
          Theme.of(context).appBarTheme.titleTextStyle?.copyWith(height: 1.2),
    ),
  );
}
