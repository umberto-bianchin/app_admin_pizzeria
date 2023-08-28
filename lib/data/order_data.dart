import 'package:app_admin_pizzeria/data/data_item.dart';
import 'package:flutter/material.dart';

class OrderData {
  OrderData(
      {required this.name,
      required this.phone,
      required this.address,
      required this.data,
      required this.accepted,
      required this.deliveryMethod,
      required this.time,
      required this.uid,
      required this.deliveryPrice,
      required this.personalPrice});

  final String name;
  final String phone;
  final String address;
  final List<DataItem> data;
  String accepted;
  final String deliveryMethod;
  String time;
  final String uid;
  double deliveryPrice = 0;
  double personalPrice = 0;

  double getTotal(BuildContext context) {
    double total = 0;
    for (DataItem item in data) {
      total += item.calculatePrice(context);
    }
    return personalPrice != 0 ? personalPrice : total + deliveryPrice;
  }
}
