import 'package:app_admin_pizzeria/providers/menu_provider.dart';
import 'package:app_admin_pizzeria/widget/menu_widget/categories_buttons_tab.dart';
import 'package:app_admin_pizzeria/widget/menu_widget/menu_item_add.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/data_item.dart';

class MenuItem extends StatefulWidget {
  const MenuItem({super.key, required this.dataItem});

  final DataItem dataItem;

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: widget.dataItem.available
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
                      child: InkWell(
                        splashColor: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  widget.dataItem.name
                                          .substring(0, 1)
                                          .toUpperCase() +
                                      widget.dataItem.name.substring(1),
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(width: 10.0),
                                if (widget.dataItem.important)
                                  const Icon(
                                    Icons.star_outline_rounded,
                                    size: 25,
                                    color: Color.fromARGB(255, 234, 211, 6),
                                  )
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            if (widget.dataItem.category != Categories.bibite)
                              Text(
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                                widget.dataItem.ingredients.join(', '),
                              ),
                          ],
                        ),
                        onTap: () {
                          if (widget.dataItem.category != Categories.bibite) {
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
                                          widget.dataItem.name,
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
                                          widget.dataItem.ingredients
                                              .join(', '),
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
                          "€${widget.dataItem.calculatePrice(context).toStringAsFixed(2)}",
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
                                        initialItem: widget.dataItem,
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
                                    .removeItem(widget.dataItem);
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              iconSize: 30,
                            ),
                            Checkbox(
                                value: widget.dataItem.available,
                                activeColor: widget.dataItem.available
                                    ? Colors.green
                                    : Colors.black,
                                onChanged: (value) {
                                  setState(() {
                                    Provider.of<MenuProvider>(context,
                                            listen: false)
                                        .changeVisibilityItem(widget.dataItem);
                                  });
                                }),
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
                  image: widget.dataItem.image,
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
