import 'dart:async';

import 'package:app_admin_pizzeria/data/data_item.dart';
import 'package:app_admin_pizzeria/data/order_data.dart';
import 'package:app_admin_pizzeria/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderData> _orders = [];
  final List<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>> listener =
      [];

  List<OrderData> get orders => _orders;

  void updateOrders() {
    listener.add(FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((result) async {
      update();
      notifyListeners();
    }));
  }

  void updatePrice(OrderData order, double price, bool isDelivery) {
    isDelivery
        ? order.deliveryPrice = price
        : order.personalPrice = price;

    notifyListeners();
  }

  void update() async {
    final documents =
        await FirebaseFirestore.instance.collection('users').get();

    for (var document in documents.docs) {
      listener.add(FirebaseFirestore.instance
          .collection('users')
          .doc(document.id)
          .collection("orders")
          .snapshots()
          .listen((event) async {
        _orders = await retrieveOrders();
        notifyListeners();
      }));
    }
  }

  void clearListener() async {
    for (var listener in listener) {
      listener.cancel();
    }
  }

  void confirmOrder(OrderData order) {
    order.accepted = "True";
    notifyListeners();
  }

  void changeIngredient(DataItem item, int index) {
    item.ingredients.removeAt(index);
    notifyListeners();
  }

  void changeQuantity(DataItem item, int quantity) {
    item.quantity = quantity;
    notifyListeners();
  }

  void removeItem(OrderData order, DataItem item) {
    order.data.remove(item);
    notifyListeners();
  }
}
