import 'package:app_admin_pizzeria/data/data_item.dart';
import 'package:app_admin_pizzeria/helper.dart';
import 'package:app_admin_pizzeria/main.dart';
import 'package:app_admin_pizzeria/providers/orders_provider.dart';
import 'package:app_admin_pizzeria/widget/order_widget/cost_picker.dart';
import 'package:app_admin_pizzeria/widget/order_widget/item_cart_add.dart';
import 'package:app_admin_pizzeria/widget/order_widget/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrdersProvider>(context).orders;
    Provider.of<OrdersProvider>(context, listen: false).getTime();

    if (orders.isNotEmpty) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ExpansionTile(
                title: Row(
                  children: [
                    orders[index].accepted == "True"
                        ? const Icon(
                            Icons.verified,
                            color: Colors.green,
                            size: 30,
                          )
                        : const Icon(
                            Icons.verified,
                            color: Color.fromARGB(255, 234, 211, 7),
                            size: 30,
                          ),
                    const SizedBox(width: 20),
                    Text(
                      order.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    const SizedBox(width: 50),
                    Text(
                      order.deliveryMethod,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                children: [
                  ListTile(
                    title: const Text(
                      "Numero di telefono",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(order.phone),
                  ),
                  if (order.deliveryMethod == "Domicilio")
                    ListTile(
                      title: const Text(
                        "Indirizzo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(order.address),
                    ),
                  if (order.deliveryMethod == "Domicilio")
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ListTile(
                        title: const Text(
                          "Costo consegna",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: CostPicker(
                          order: order,
                          isDelivery: true,
                        ),
                      ),
                    ),
                  ListTile(
                      title: const Text(
                        "Orario",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: TimePicker(
                        order: order,
                      )),
                  const ListTile(
                    title: Text(
                      "Ordine:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  for (DataItem item in order.data)
                    ListTile(
                      title: Text(item.dataName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.getIngredients()),
                          Text(
                            "€ ${item.calculatePrice(context).toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                      trailing: Text("Quantitá: ${item.quantity}"),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ItemCart(dataItem: item, order: order);
                            });
                      },
                    ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: const Text("Inserisci il prezzo"),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CostPicker(
                                    order: order,
                                    isDelivery: false,
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    label: Text(
                      "Totale: € ${order.getTotal(context).toStringAsFixed(2)}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    icon: const Icon(Icons.edit),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 155,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              submitOrder(context,
                                  order: order, accepted: false);
                            },
                            child: const Text("Rifiuta ordine"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 155,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: order.accepted == "False"
                                    ? Colors.blue
                                    : Colors.green),
                            onPressed: () {
                              submitOrder(context,
                                  order: order, accepted: true);
                            },
                            child: Text(order.accepted == "False"
                                ? "Conferma ordine"
                                : "Modifica ordine"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    } else {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Nessun ordine presente",
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 50),
          ),
        ),
      );
    }
  }
}
