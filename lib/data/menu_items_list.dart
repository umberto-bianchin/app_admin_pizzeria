import 'package:app_admin_pizzeria/data/data_item.dart';

enum Ingredients {
  pomodoro,
  mozzarella,
  cotto,
  salsiccia,
  salamino,
  piselli,
  peperoni,
  zucchine,
  grana,
  funghi,
  cipolla,
  gorgonzola,
  wustel,
  tonno,
  salamino_piccante,
  verdure_al_forno,
}

String toStringIngredients(Ingredients ingredient) {
  return ingredient.name.replaceAll("_", " ");
}

Map<String, List<dynamic>> information = {
  "Margherita": [
    6.99,
    Categories.pizza,
    "assets/images/classic.png",
    [Ingredients.pomodoro, Ingredients.mozzarella]
  ],
  "Diavola": [
    7.99,
    Categories.pizza,
    "assets/images/americana.png",
    [
      Ingredients.pomodoro,
      Ingredients.mozzarella,
      Ingredients.salamino_piccante
    ]
  ],
  "Vegetariana": [
    4.99,
    Categories.pizza,
    "assets/images/veg.png",
    [Ingredients.pomodoro, Ingredients.mozzarella, Ingredients.verdure_al_forno]
  ],
  "Prosciutto e Funghi": [
    6.99,
    Categories.pizza,
    "assets/images/mexicanPizza.png",
    [
      Ingredients.pomodoro,
      Ingredients.mozzarella,
      Ingredients.cotto,
      Ingredients.funghi
    ]
  ],
  "Bea": [
    9.0,
    Categories.pizza,
    "assets/images/mexicanPizza.png",
    [
      Ingredients.pomodoro,
      Ingredients.mozzarella,
      Ingredients.cotto,
      Ingredients.salsiccia,
      Ingredients.salamino,
      Ingredients.piselli,
      Ingredients.peperoni,
      Ingredients.gorgonzola,
      Ingredients.grana
    ]
  ],
  "Tonno e Cipolla": [
    6.99,
    Categories.pizza,
    "assets/images/mexicanPizza.png",
    [
      Ingredients.pomodoro,
      Ingredients.mozzarella,
      Ingredients.tonno,
      Ingredients.cipolla
    ]
  ],
  "Wurstel": [
    14.0,
    Categories.kebab,
    "assets/images/pizza.png",
    [Ingredients.pomodoro, Ingredients.mozzarella, Ingredients.wustel]
  ],
  "A4": [
    6.5,
    Categories.panini,
    "assets/images/burger.png",
    [
      Ingredients.mozzarella,
      Ingredients.salsiccia,
      Ingredients.cipolla,
      Ingredients.gorgonzola,
      Ingredients.funghi
    ]
  ],
  "Coca Cola": [2.0, Categories.bibite, "assets/images/drink.png", []],
  "Acqua": [1.0, Categories.bibite, "assets/images/drink.png", []],
};

Map<Ingredients, double> costIngredients = {
  Ingredients.pomodoro: 0.55,
  Ingredients.mozzarella: 0.55,
  Ingredients.cotto: 0.55,
  Ingredients.salsiccia: 0.55,
  Ingredients.salamino: 0.55,
  Ingredients.piselli: 0.55,
  Ingredients.peperoni: 0.55,
  Ingredients.zucchine: 0.55,
  Ingredients.grana: 0.55,
  Ingredients.funghi: 0.55,
  Ingredients.cipolla: 0.55,
  Ingredients.gorgonzola: 0.55,
  Ingredients.wustel: 0.55,
  Ingredients.tonno: 0.55,
  Ingredients.salamino_piccante: 0.55,
  Ingredients.verdure_al_forno: 0.55,
};
