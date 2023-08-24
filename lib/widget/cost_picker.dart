import 'package:app_admin_pizzeria/data/order_data.dart';
import 'package:app_admin_pizzeria/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CostPicker extends StatefulWidget {
  CostPicker({super.key, required this.order})
      : controller =
            TextEditingController(text: order.deliveryPrice.toString());
  final TextEditingController controller;
  final OrderData order;

  @override
  State<CostPicker> createState() => _CostPickerState();
}

class _CostPickerState extends State<CostPicker> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 90,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Form(
              key: formKey,
              child: TextFormField(
                keyboardType: TextInputType.number,
                cursorColor: Colors.black,
                autocorrect: false,
                controller: widget.controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == "") return null;

                  if (double.tryParse(value!) == null) {
                    return "Inserire un valore con il punto";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: const Color.fromARGB(255, 231, 231, 231),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color.fromARGB(255, 41, 41, 41)),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Provider.of<OrdersProvider>(context, listen: false).updatePrice(
                  widget.order, double.parse(widget.controller.text));
            }
          },
          child: const Text("Conferma prezzo"),
        )
      ],
    );
  }
}
