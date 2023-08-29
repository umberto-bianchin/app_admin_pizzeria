import 'package:app_admin_pizzeria/providers/menu_provider.dart';
import 'package:app_admin_pizzeria/widget/menu_widget/categories_buttons_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DataItem {
  DataItem({
    required this.key,
    required this.image,
    required this.name,
    required this.ingredients,
    required this.initialPrice,
    required this.category,
    this.important = false,
    this.quantity = 1,
  });

  NetworkImage image;
  String name;
  List<String> ingredients;
  double initialPrice;
  final Categories category;
  final UniqueKey key;
  int quantity;
  bool important;

  String get dataName => name;

  void addIngredients(String ingredient) {
    
    ingredients.add(ingredient);
  }

  double calculatePrice(BuildContext context) {
    try {
      double price = initialPrice;
      DataItem baseItem = Provider.of<MenuProvider>(context, listen: false)
          .menu
          .firstWhere((element) => element.name == name);
      
      

      for (String ingredient in ingredients) {
        if (!baseItem.ingredients.contains(ingredient)) {
          price = price + Provider.of<MenuProvider>(context, listen: false).ingredients[ingredient]!;
        }
      }
      return price * quantity;
    } catch (e) {
      return 0.0;
    }
  }

  DataItem copy() {
    return DataItem(
      key: UniqueKey(),
      image: image,
      name: name,
      ingredients: ingredients,
      initialPrice: initialPrice,
      category: category,
      quantity: quantity,
    );
  }

  String getIngredients() {
    return ingredients.join(', ');
  }
}
