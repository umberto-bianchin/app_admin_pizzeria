import 'package:app_admin_pizzeria/data/data_item.dart';
import 'package:app_admin_pizzeria/helper.dart';
import 'package:flutter/material.dart';

class MenuProvider with ChangeNotifier {
  List<DataItem> menu = [];
  Map<String, List<dynamic>> ingredients = {};

  void retrieveMenu() async {
    menu = await getMenu();
  }

  void retrieveIngredients() async {
    ingredients = await getSavedIngredients();
  }

  void addItem(DataItem item) {
    menu.removeWhere((element) => element.name == item.name);
    menu.add(item);
    notifyAll();
  }

  void removeItem(DataItem item) {
    menu.remove(item);
    notifyAll();
  }

  void hideIngredient(String ingredient, bool value) {
    ingredients[ingredient]![1] = value;
    changeVisibilityWithIngredient(ingredient, value);
    saveIngredients(ingredients);
    notifyAll();
  }

  void changeVisibilityWithIngredient(String ingredient, bool value) {
    if (!value) {
      for (DataItem item in menu) {
        if (item.ingredients.any((ingr) => ingr == ingredient)) {
          item.available = false;
        }
      }
    } else {
      for (DataItem item in menu) {
        if (item.ingredients.every(
            (ingr) => ingredients.containsKey(ingr) && ingredients[ingr]![1])) {
          item.available = true;
        }
      }
    }
  }

  void changeVisibilityItem(DataItem item) {
    item.available = !item.available;
    saveMenu(menu);
  }

  void notifyAll() {
    saveMenu(menu);
    notifyListeners();
  }

  void addIngredient(String ingredient, double price) {
    ingredients.removeWhere((key, value) => key == ingredient);
    ingredients[ingredient] = [price, true];
    changeVisibilityWithIngredient(ingredient, true);
    saveIngredients(ingredients);
    notifyAll();
  }

  void removeIngredient(String ingredient) {
    ingredients.remove(ingredient);
    changeVisibilityWithIngredient(ingredient, false);
    saveIngredients(ingredients);
    notifyAll();
  }
}
