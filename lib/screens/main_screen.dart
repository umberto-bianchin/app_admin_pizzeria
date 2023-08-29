import 'package:app_admin_pizzeria/main.dart';
import 'package:app_admin_pizzeria/providers/orders_provider.dart';
import 'package:app_admin_pizzeria/providers/page_provider.dart';
import 'package:app_admin_pizzeria/responsive.dart';
import 'package:app_admin_pizzeria/screens/dashboard_screen.dart';
import 'package:app_admin_pizzeria/screens/maps_screen.dart';
import 'package:app_admin_pizzeria/screens/menu_screen.dart';
import 'package:app_admin_pizzeria/screens/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/header.dart';
import '../widget/side_menu.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<Widget> _displayed =  [
    const DashboardScreen(),
    MapScreen(),
    const MenuScreen(),
    const OrderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final int index = Provider.of<PageProvider>(context).selectedPage;
    Provider.of<OrdersProvider>(context, listen: false).updateOrders(context);

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
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Header(),
                  ),
                  _displayed[index],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
