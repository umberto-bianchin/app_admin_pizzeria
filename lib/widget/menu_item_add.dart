import 'package:app_admin_pizzeria/data/menu_items_list.dart';
import 'package:app_admin_pizzeria/providers/menu_provider.dart';
import 'package:app_admin_pizzeria/providers/page_provider.dart';
import 'package:app_admin_pizzeria/widget/categories_buttons_tab.dart';
import 'package:app_admin_pizzeria/widget/menu_item_cost.dart';
import 'package:app_admin_pizzeria/widget/my_dialog.dart';
import 'package:app_admin_pizzeria/widget/search_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/data_item.dart';

class MenuAdd extends StatefulWidget {
  const MenuAdd({super.key, this.initialItem});

  final DataItem? initialItem;

  @override
  State<MenuAdd> createState() => _MenuAddState();
}

class _MenuAddState extends State<MenuAdd> {
  final ScrollController _controller = ScrollController();
  TextEditingController? nameController;
  TextEditingController? costController;

  String searchedValue = "";
  DataItem? customItem;

  @override
  void initState() {
    super.initState();

    if (widget.initialItem != null) {
      customItem = widget.initialItem;

      nameController = TextEditingController(text: customItem!.name);
      costController =
          TextEditingController(text: customItem!.initialPrice.toString());

      return;
    }

    nameController = TextEditingController();
    costController = TextEditingController();

    customItem = DataItem(
      key: UniqueKey(),
      image: listCategories
          .firstWhere((element) =>
              element.category ==
              Provider.of<PageProvider>(context, listen: false)
                  .selectedCategory)
          .icon,
      name: "",
      ingredients: [],
      initialPrice: 0.0,
      category:
          Provider.of<PageProvider>(context, listen: false).selectedCategory,
    );
  }

  void setSearchedValue(String search) {
    setState(() {
      searchedValue = search;
    });
  }

  void addIngredients(Ingredients ingredient) {
    setState(() {
      customItem!.addIngredients(ingredient);
    });
  }

  void removeIngredient(int index) {
    setState(() {
      customItem!.ingredients.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        alignment: Alignment.center,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 400,
                      child: TextField(
                        controller: nameController,
                        autocorrect: false,
                        style: Theme.of(context).textTheme.titleLarge,
                        decoration:
                            const InputDecoration(hintText: "Inserisci nome"),
                      ),
                    ),
                    Image(
                      image: AssetImage(customItem!.image),
                      height: 100.0,
                    ),
                    Column(
                      children: [
                        const Text(
                          "Prezzo\t\t\t",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        MenuItemCost(
                          costController: costController!,
                        ),
                      ],
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
                        if (nameController!.text == "" ||
                            double.tryParse(costController!.text) == null ||
                            (customItem!.ingredients.isEmpty &&
                                customItem!.category != Categories.bibite)) {
                          MyDialog.showMyDialog(context,
                              message: "Compila tutti i campi",
                              title: "Errore");
                          return;
                        }

                        customItem!.name = nameController!.text;
                        customItem!.initialPrice =
                            double.parse(costController!.text);

                        information[customItem!.name] = [
                          customItem!.initialPrice,
                          customItem!.category,
                          customItem!.image,
                          customItem!.ingredients
                        ];

                        if (widget.initialItem == null) {
                          Provider.of<MenuProvider>(context, listen: false)
                              .addItem(customItem!);
                        }

                        Provider.of<MenuProvider>(context, listen: false)
                            .notifyAll();

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
