import 'package:app_admin_pizzeria/providers/page_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Categories {
  pizza,
  bibite,
  panini,
  kebab,
}

final List<Pair> listCategories = [
  Pair("assets/images/classic.png", Categories.pizza),
  Pair("assets/images/mexican.png", Categories.kebab),
  Pair("assets/images/burger.png", Categories.panini),
  Pair("assets/images/drink.png", Categories.bibite),
];

class CategoriesButton extends StatelessWidget {
  const CategoriesButton({super.key});

  @override
  Widget build(BuildContext context) {
    final Categories selectedCategory =
        Provider.of<PageProvider>(context).selectedCategory;

    return SizedBox(
      height: 40.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 10),
        children: [
          for (Pair pair in listCategories)
            category(
                pair.category == selectedCategory
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                pair.category,
                pair.icon,
                pair.category == selectedCategory ? Colors.white : Colors.black,
                listCategories.indexOf(pair),
                context),
        ],
      ),
    );
  }

  Widget category(Color colore, Categories nameCat, String menuImage,
      Color menuColor, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: InkWell(
        child: Container(
          alignment: Alignment.center,
          height: 40.0,
          width: 100.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: colore),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(menuImage),
                height: 20.0,
                width: 20.0,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                capitalize(nameCat.name),
                style: TextStyle(
                  color: menuColor,
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Provider.of<PageProvider>(context, listen: false)
              .changeCategory(nameCat);
        },
      ),
    );
  }
}

String capitalize(String value) {
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

class Pair {
  Pair(this.icon, this.category);

  String icon;
  Categories category;
}
