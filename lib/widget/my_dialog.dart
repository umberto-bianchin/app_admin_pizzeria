import 'package:flutter/material.dart';

class MyDialog {
  static void showMyDialog(BuildContext context,
      {required String message, required String title}) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            alignment: Alignment.center,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                    icon: const Icon(Icons.close),
                    color: const Color(0xFF1F91E7),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
            children: [
              Center(
                child: Text(message),
              )
            ],
          );
        });
  }
}
