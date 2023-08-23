import 'package:app_admin_pizzeria/responsive.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

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
      ],
    );
  }
}
