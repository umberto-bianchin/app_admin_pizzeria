import 'package:app_admin_pizzeria/data/data_item.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  List<DataItem> menu = [];

  void addItem(DataItem item) {
    menu.removeWhere((element) => element.name == item.name);
    menu.add(item);
    notifyListeners();
  }

  void removeItem(DataItem item) {
    menu.remove(item);
    notifyListeners();
  }

  void notifyAll() {
    notifyListeners();
  }
}
