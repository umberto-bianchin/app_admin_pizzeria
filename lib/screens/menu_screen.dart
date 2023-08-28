import 'package:app_admin_pizzeria/constants.dart';
import 'package:app_admin_pizzeria/data/data_item.dart';
import 'package:app_admin_pizzeria/providers/menu_provider.dart';
import 'package:app_admin_pizzeria/providers/page_provider.dart';
import 'package:app_admin_pizzeria/widget/categories_buttons_tab.dart';
import 'package:app_admin_pizzeria/widget/ingredient_item.dart';
import 'package:app_admin_pizzeria/widget/ingredient_item_add.dart';
import 'package:app_admin_pizzeria/widget/menu_item.dart';
import 'package:app_admin_pizzeria/widget/menu_item_add.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Categories selectedCategory =
        Provider.of<PageProvider>(context).selectedCategory;

    final menu = Provider.of<MenuProvider>(context).menu;
    final ingredients = Provider.of<MenuProvider>(context).ingredients;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CategoriesButton(),
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          height: MediaQuery.of(context).size.height / 1.5,
          child: ListView(
            children: [
              if (selectedCategory != Categories.ingredienti)
                for (DataItem item in menu
                    .where((element) => element.category == selectedCategory)
                    .toList())
                  MenuItem(
                    dataItem: item,
                  )
              else
                for (String ingredient in ingredients.keys)
                  IngredientItem(ingredient: ingredient),
            ],
          ),
        ),
        OutlinedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    if (selectedCategory != Categories.ingredienti) {
                      return const MenuAdd();
                    } else {
                      return  const IngredientAdd();
                    }
                  });
            },
            child: Text("Aggiungi ${selectedCategory.name}"))
      ],
    );
  }
}
