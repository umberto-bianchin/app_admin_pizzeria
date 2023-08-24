import 'package:app_admin_pizzeria/constants.dart';
import 'package:app_admin_pizzeria/data/data_item.dart';
import 'package:app_admin_pizzeria/data/order_data.dart';
import 'package:app_admin_pizzeria/helper.dart';
import 'package:app_admin_pizzeria/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<OrderData> orders = Provider.of<OrdersProvider>(context).orders;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return ExpansionTile(
              title: Text(order.name),
              subtitle: Text(order.deliveryMethod),
              children: [
                ListTile(
                  title: const Text(
                    "Numero di telefono",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(order.phone),
                ),
                if (order.deliveryMethod == "Domicilio")
                  ListTile(
                    title: const Text("Indirizzo"),
                    trailing: Text(order.address),
                  ),
                for (DataItem item in order.data)
                  ListTile(
                    title: Text(item.dataName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.getIngredients()),
                        Text(
                          "€ ${item.calculatePrice().toStringAsFixed(2)}",
                        ),
                      ],
                    ),
                    trailing: Text("Quantitá: ${item.quantity}"),
                  ),
                const SizedBox(height: 10),
                Text(
                  "Totale: ${order.getTotal().toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: ElevatedButton(
                    onPressed: order.accepted == "False"
                        ? () {
                            confirmOrder(context, order);
                          }
                        : null,
                    child: Text(order.accepted == "False"
                        ? "Conferma ordine"
                        : "Ordine confermato"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
