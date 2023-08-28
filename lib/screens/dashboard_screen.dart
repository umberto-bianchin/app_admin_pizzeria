import 'package:app_admin_pizzeria/main.dart';
import 'package:app_admin_pizzeria/responsive.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              const SizedBox(height: defaultPadding),
              if (Responsive.isMobile(context))
                const SizedBox(height: defaultPadding),
              if (Responsive.isMobile(context)) const Placeholder(),
            ],
          ),
        ),
        if (!Responsive.isMobile(context))
          const SizedBox(width: defaultPadding),
        // On Mobile means if the screen is less than 850 we don't want to show it
        if (!Responsive.isMobile(context))
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
      ],
    );
  }
}
