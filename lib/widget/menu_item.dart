import 'package:app_admin_pizzeria/providers/menu_provider.dart';
import 'package:app_admin_pizzeria/widget/categories_buttons_tab.dart';
import 'package:app_admin_pizzeria/widget/menu_item_add.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_item.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({super.key, required this.dataItem});

  final DataItem dataItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: SizedBox(
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
                    child: InkWell(
                      splashColor: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            overflow: TextOverflow.ellipsis,
                            dataItem.name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          if (dataItem.category != Categories.bibite)
                            Text(
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey),
                              dataItem.ingredients.join(', '),
                            ),
                        ],
                      ),
                      onTap: () {
                        if (dataItem.category != Categories.bibite) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  alignment: Alignment.center,
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dataItem.name,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      IconButton(
                                          icon: const Icon(Icons.close),
                                          color: const Color(0xFF1F91E7),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          })
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 20, bottom: 20),
                                      child: Text(
                                        dataItem.ingredients.join(', '),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "€${dataItem.calculatePrice(context).toStringAsFixed(2)}",
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
                                    return MenuAdd(
                                      initialItem: dataItem,
                                    );
                                  });
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.blue,
                            iconSize: 30,
                          ),
                          IconButton(
                            onPressed: () {
                              Provider.of<MenuProvider>(context, listen: false)
                                  .removeItem(dataItem);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            iconSize: 30,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              left: 0.0,
              child: Image(
                image: dataItem.image,
                height: 100.0,
                width: 100.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
