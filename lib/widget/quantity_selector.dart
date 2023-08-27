import 'package:flutter/material.dart';

class NumericStepButton extends StatefulWidget {
  const NumericStepButton({
    super.key,
    this.minValue = 1,
    required this.onChanged,
    this.initialValue = 1,
  });

  final int minValue;
  final ValueChanged<int> onChanged;
  final int initialValue;

  @override
  State<NumericStepButton> createState() {
    return _NumericStepButtonState();
  }
}

class _NumericStepButtonState extends State<NumericStepButton> {
  int? counter;

  @override
  void initState() {
    super.initState();
    counter = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Quantità",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(
                Icons.remove,
                color: Colors.red,
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              iconSize: 25.0,
              onPressed: () {
                setState(() {
                  if (counter! > widget.minValue) {
                    counter = counter! - 1;
                  }
                  widget.onChanged(counter!);
                });
              },
            ),
            Text(
              '$counter',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.green,
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              iconSize: 25.0,
              onPressed: () {
                setState(() {
                  counter = counter! + 1;
                  widget.onChanged(counter!);
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
