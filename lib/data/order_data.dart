import 'package:app_admin_pizzeria/data/data_item.dart';

class OrderData {
  OrderData(
      {required this.name,
      required this.phone,
      required this.address,
      required this.data,
      required this.accepted,
      required this.deliveryMethod,
      required this.time,
      required this.uid});

  final String name;
  final String phone;
  final String address;
  final List<DataItem> data;
  String accepted;
  final String deliveryMethod;
  String time;
  final String uid;
  double deliveryPrice = 0;

  double getTotal() {
    double total = 0;
    for (DataItem item in data) {
      total += item.calculatePrice();
    }
    return total+deliveryPrice;
  }
}
