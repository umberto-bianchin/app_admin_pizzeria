import 'package:flutter/material.dart';
import '../constants.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
               SizedBox(height: defaultPadding),
              
            ],
          ),
        ),
      ],
    );
  }
}
