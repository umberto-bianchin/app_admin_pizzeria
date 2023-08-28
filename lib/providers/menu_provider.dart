import 'package:app_admin_pizzeria/data/data_item.dart';
import 'package:app_admin_pizzeria/helper.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  List<DataItem> menu = [];

  void retrieveMenu() async {
    menu = await getMenu();
  }

  void addItem(DataItem item) {
    menu.removeWhere((element) => element.name == item.name);
    menu.add(item);
    saveMenu(menu);
    notifyListeners();
  }

  void removeItem(DataItem item) {
    menu.remove(item);
    saveMenu(menu);
    notifyListeners();
  }

  void notifyAll() {
    saveMenu(menu);
    notifyListeners();
  }
}
