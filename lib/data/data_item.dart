import 'package:flutter/material.dart';
import 'menu_items_list.dart';

enum Categories {
  pizza,
  bibite,
  panini,
  kebab,
}

class DataItem {
  DataItem({
    required this.key,
    required this.image,
    required this.name,
    required this.ingredients,
    required this.initialPrice,
    required this.category,
    this.quantity = 1,
  });

  final String image;
  final String name;
  List<Ingredients> ingredients;
  final double initialPrice;
  final Categories category;
  final UniqueKey key;
  int quantity;

  String get dataName => name;

  void addIngredients(Ingredients ingredient) {
    ingredients.add(ingredient);
  }

  double calculatePrice() {
    double price = initialPrice;
    for (Ingredients ingredient in ingredients) {
      if (!information[name]![3].contains(ingredient)) {
        price = price + costIngredients[ingredient]!;
      }
    }
    return price * quantity;
  }

  DataItem copy() {
    return DataItem(
      key: UniqueKey(),
      image: image,
      name: name,
      ingredients: List.from(ingredients),
      initialPrice: initialPrice,
      category: category,
      quantity: quantity,
    );
  }

  void clearList() {
    final indexes = [];
    for (Ingredients ingredient in ingredients) {
      indexes.add(ingredients.indexOf(ingredient));
    }

    for (int index in indexes) {
      ingredients.removeAt(index);
    }
  }

  String getIngredients() {
    return ingredients
        .map((element) => element.name.replaceAll("_", " "))
        .join(', ');
  }
}
