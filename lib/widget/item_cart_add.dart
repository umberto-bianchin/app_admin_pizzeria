import 'package:app_admin_pizzeria/data/menu_items_list.dart';
import 'package:app_admin_pizzeria/data/order_data.dart';
import 'package:app_admin_pizzeria/providers/orders_provider.dart';
import 'package:app_admin_pizzeria/widget/quantity_selector.dart';
import 'package:app_admin_pizzeria/widget/search_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/data_item.dart';

class ItemCart extends StatefulWidget {
  const ItemCart({super.key, required this.dataItem, required this.order});

  final DataItem dataItem;
  final OrderData order;

  @override
  State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  String? dropdownValue;
  final ScrollController _controller = ScrollController();
  String searchedValue = "";
  DataItem? customItem;
  int quantity = 1;

  void setSearchedValue(String search) {
    setState(() {
      searchedValue = search;
    });
  }

  void setQuantity(int x) {
    setState(() {
      quantity = x;
      customItem!.quantity = x;
    });
  }

  void addIngredients(Ingredients ingredient) {
    setState(() {
      customItem!.addIngredients(ingredient);
    });
  }

  void removeIngredient(int index) {
    setState(() {
      context.read<OrdersProvider>().changeIngredient(customItem!, index);
    });
  }

  @override
  void initState() {
    super.initState();
    customItem = widget.dataItem;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        alignment: Alignment.center,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              customItem!.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
                icon: const Icon(Icons.close),
                color: const Color(0xFF1F91E7),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        ),
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: const EdgeInsets.only(left: 25, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image(
                      image: AssetImage(customItem!.image),
                      height: 100.0,
                    ),
                    NumericStepButton(
                      onChanged: setQuantity,
                      minValue: 0,
                      initialValue: customItem!.quantity,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (customItem!.category != Categories.bibite)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Ingredienti:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 5,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: _controller,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ListView(
                                  controller: _controller,
                                  shrinkWrap: true,
                                  children: [
                                    for (int i = 0;
                                        i < customItem!.ingredients.length;
                                        i++)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            capitalize(
                                              toStringIngredients(
                                                  customItem!.ingredients[i]),
                                            ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          ElevatedButton(
                                              child: const Text("Rimuovi"),
                                              onPressed: () {
                                                removeIngredient(i);
                                              }),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Prezzo\t\t\t",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      "€${(customItem!.calculatePrice()).toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 15, color: Colors.red),
                    ),
                  ],
                ),
                if (customItem!.category != Categories.bibite)
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      SizedBox(
                        child: SearchIngredient(onChange: setSearchedValue),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 40.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(right: 10),
                          children: [
                            for (Ingredients ingredient in Ingredients.values)
                              if (!customItem!.ingredients
                                      .contains(ingredient) &&
                                  toStringIngredients(ingredient)
                                      .contains(searchedValue))
                                ingredientButton(ingredient,
                                    Ingredients.values.indexOf(ingredient)),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(120, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        "Chiudi",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 5),
                    OutlinedButton(
                      onPressed: () {
                        context
                            .read<OrdersProvider>()
                            .changeQuantity(customItem!, quantity);

                        if (quantity == 0) {
                          context
                              .read<OrdersProvider>()
                              .removeItem(widget.order, customItem!);
                        }

                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        fixedSize: const Size(120, 20),
                        backgroundColor: Colors.grey[350],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        "Conferma",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ]);
  }

  Widget ingredientButton(Ingredients ingredient, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: OutlinedButton(
        onPressed: () {
          addIngredients(ingredient);
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          children: [
            Text(
              capitalize(toStringIngredients(ingredient)),
              style: TextStyle(color: Colors.grey[800]),
            ),
            const SizedBox(width: 8),
            Text(
              "+€${costIngredients[ingredient]}",
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

String capitalize(String value) {
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}
