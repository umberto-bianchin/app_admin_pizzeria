import 'package:app_admin_pizzeria/data/order_data.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({super.key, required this.order});

  final OrderData order;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("Orario desiderato: ${widget.order.time}"),
        const SizedBox(width: 20),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color.fromARGB(255, 41, 41, 41)),
          ),
          onPressed: () async {
            final time = await showTimePicker(
                initialEntryMode: TimePickerEntryMode.inputOnly,
                cancelText: "Cancella",
                confirmText: "Conferma",
                hourLabelText: "Ora",
                minuteLabelText: "Minuti",
                errorInvalidText: "Inserisci un orario valido",
                helpText: "Inserisci l'orario di consegna desiderato",
                context: context,
                initialTime: TimeOfDay(
                    hour: int.parse(widget.order.time.substring(0, 2)),
                    minute: int.parse(
                      widget.order.time.substring(3),
                    )),
                builder: (context, childWidget) {
                  return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: childWidget!);
                });

            setState(() {
              widget.order.time = time!.to24hours();
            });
          },
          child: const Text("Cambia orario"),
        ),
      ],
    );
  }
}

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hr = hour.toString().padLeft(2, "0");
    final min = minute.toString().padLeft(2, "0");
    return "$hr:$min";
  }
}
