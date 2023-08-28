import 'package:flutter/material.dart';

class MenuItemCost extends StatelessWidget {
  MenuItemCost({super.key, required this.costController});
  final formKey = GlobalKey<FormState>();
  final TextEditingController costController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          height: 90,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Form(
              key: formKey,
              child: TextFormField(
                keyboardType: TextInputType.number,
                cursorColor: Colors.black,
                autocorrect: false,
                controller: costController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == "") return null;

                  if (double.tryParse(value!) == null) {
                    return "Inserire un valore con il punto";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  fillColor: const Color.fromARGB(255, 231, 231, 231),
                  filled: true,
                  hintText: "0.0",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
