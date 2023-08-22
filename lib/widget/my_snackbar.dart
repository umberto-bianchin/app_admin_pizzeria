import 'package:flutter/material.dart';

class MySnackBar {
  static void showMySnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.red,
        duration: const Duration(seconds: 1),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        backgroundColor: const Color.fromARGB(255, 229, 228, 228),
      ),
    );
  }
}
