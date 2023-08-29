import 'package:flutter/material.dart';

class SearchIngredient extends StatefulWidget {
  const SearchIngredient({super.key, required this.onChange});

  final void Function(String) onChange;

  @override
  State<SearchIngredient> createState() => _SearchIngredientState();
}

class _SearchIngredientState extends State<SearchIngredient> {
  Icon currentIcon = const Icon(
    Icons.search,
    size: 28,
  );
  Widget displayed = const Text(
    "Aggiungi un ingrediente:",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          displayed,
          IconButton(
            icon: currentIcon,
            onPressed: () {
              setState(() {
                if (currentIcon.icon == Icons.search) {
                  currentIcon = const Icon(Icons.cancel);
                  displayed = SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: TextField(
                      onChanged: widget.onChange,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Cerca',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  );
                } else {
                  displayed = const Text(
                    "Aggiungi un ingrediente:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  );
                  currentIcon = const Icon(
                    Icons.search,
                    size: 28,
                  );
                  widget.onChange("");
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
