import 'package:app_admin_pizzeria/helper.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: () {
              logOut(context);
            },
            child: Text("Logout"))
      ],
    );
  }
}
