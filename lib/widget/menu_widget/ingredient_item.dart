import 'package:app_admin_pizzeria/providers/menu_provider.dart';
import 'package:app_admin_pizzeria/widget/menu_widget/ingredient_item_add.dart';
import 'package:app_admin_pizzeria/widget/menu_widget/menu_item_add.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientItem extends StatelessWidget {
  const IngredientItem({super.key, required this.ingredient});

  final String ingredient;

  @override
  Widget build(BuildContext context) {
    bool available =
        Provider.of<MenuProvider>(context).ingredients[ingredient]![1];

    return ColorFiltered(
      colorFilter: available
          ? const ColorFilter.mode(
              Colors.transparent,
              BlendMode.multiply,
            )
          : const ColorFilter.mode(
              Color.fromARGB(255, 218, 218, 218),
              BlendMode.saturation,
            ),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          height: 100.0,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 115.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            overflow: TextOverflow.ellipsis,
                            capitalize(ingredient),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "€ ${Provider.of<MenuProvider>(context, listen: false).ingredients[ingredient]![0]}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              fontSize: 15.0),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return IngredientAdd(
                                        ingredient: ingredient,
                                      );
                                    });
                              },
                              icon: const Icon(Icons.edit),
                              color: Colors.blue,
                              iconSize: 30,
                            ),
                            IconButton(
                              onPressed: () {
                                Provider.of<MenuProvider>(context,
                                        listen: false)
                                    .removeIngredient(ingredient);
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              iconSize: 30,
                            ),
                            Checkbox(
                                value: available,
                                onChanged: (value) {
                                  Provider.of<MenuProvider>(context,
                                          listen: false)
                                      .hideIngredient(ingredient, value!);
                                }),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Positioned(
                left: 0.0,
                child: Image(
                  image: AssetImage("assets/images/pastry.png"),
                  height: 100.0,
                  width: 100.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
