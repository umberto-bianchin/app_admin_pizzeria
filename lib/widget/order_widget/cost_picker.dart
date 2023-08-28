import 'package:app_admin_pizzeria/data/order_data.dart';
import 'package:app_admin_pizzeria/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CostPicker extends StatelessWidget {
  CostPicker({super.key, required this.order, required this.isDelivery});

  final OrderData order;
  final bool isDelivery;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(
        text: isDelivery
            ? order.deliveryPrice.toString()
            : order.getTotal(context).toString());

    return Row(
      mainAxisAlignment:
          isDelivery ? MainAxisAlignment.start : MainAxisAlignment.center,
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
                controller: controller,
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
                  order, double.parse(controller.text), isDelivery);
            }

            if (!isDelivery) Navigator.of(context).pop();
          },
          child: const Text("Conferma prezzo"),
        )
      ],
    );
  }
}
