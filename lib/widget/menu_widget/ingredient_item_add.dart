import 'package:app_admin_pizzeria/providers/menu_provider.dart';
import 'package:app_admin_pizzeria/widget/menu_widget/menu_item_cost.dart';
import 'package:app_admin_pizzeria/widget/my_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientAdd extends StatelessWidget {
  const IngredientAdd({super.key, this.ingredient});

  final String? ingredient;

  @override
  Widget build(BuildContext context) {
    final cost = Provider.of<MenuProvider>(context, listen: false)
        .ingredients[ingredient];
    final costController = TextEditingController(text: cost?.toString());
    final nameController = TextEditingController(text: ingredient);

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
                    const Image(
                      image: AssetImage("assets/images/pastry.png"),
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
                          costController: costController,
                        ),
                      ],
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
                        if (nameController.text == "" ||
                            double.tryParse(costController.text) == null) {
                          MyDialog.showMyDialog(context,
                              message: "Compila tutti i campi",
                              title: "Errore");
                          return;
                        }

                        Provider.of<MenuProvider>(context, listen: false)
                            .addIngredient(nameController.text.toLowerCase(),
                                double.parse(costController.text));
                          

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
}
