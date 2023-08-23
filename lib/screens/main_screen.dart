import 'package:app_admin_pizzeria/responsive.dart';
import 'package:app_admin_pizzeria/screens/dashboard_screen.dart';
import 'package:app_admin_pizzeria/screens/maps_screen.dart';
import 'package:app_admin_pizzeria/screens/menu_screen.dart';
import 'package:app_admin_pizzeria/screens/order_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widget/header.dart';
import '../widget/side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.index});

  final int index;

  final List<Widget> displayed = const [
    DashboardScreen(),
    MapScreen(),
    MenuScreen(),
    OrderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: SingleChildScrollView(
                primary: false,
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    const Header(),
                    displayed[index],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
