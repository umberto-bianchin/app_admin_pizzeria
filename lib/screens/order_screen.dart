import 'package:app_admin_pizzeria/data/order_data.dart';
import 'package:app_admin_pizzeria/helper.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<OrderData>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = retrieveOrders(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderData>>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Errore durante il recupero degli ordini'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Nessun ordine disponibile'),
          );
        } else {
          return SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                return ListTile(
                  title: Text('Ordine ${order.data[0].dataName}'),
                  subtitle: Text('Totale: ${order.price}'),
                  // Altre informazioni sull'ordine possono essere visualizzate qui
                );
              },
            ),
          );
        }
      },
    );
  }
}
