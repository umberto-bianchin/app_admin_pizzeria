import 'package:app_admin_pizzeria/data/data_item.dart';

class OrderData {
  OrderData({
    required this.data,
    required this.accepted,
    required this.deliveryMethod,
    required this.time,
    required this.price,
  });

  final List<DataItem> data;
  final String accepted;
  final String deliveryMethod;
  final String time;
  final String price;
}
