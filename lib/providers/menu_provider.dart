import 'package:app_admin_pizzeria/data/data_item.dart';
import 'package:app_admin_pizzeria/helper.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  List<DataItem> menu = [];
  Map<String, double> ingredients = {};

  void retrieveMenu() async {
    menu = await getMenu();
  }

  void retrieveIngredients() async {
    ingredients = await getSavedIngredients();
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

  void addIngredient(String ingredient, double price) {
    ingredients.removeWhere((key, value) => key == ingredient);
    ingredients[ingredient] = price;

    saveIngredients(ingredients);
    notifyListeners();
  }

  void removeIngredient(String ingredient) {
    ingredients.remove(ingredient);
    saveIngredients(ingredients);
    notifyListeners();
  }
}
