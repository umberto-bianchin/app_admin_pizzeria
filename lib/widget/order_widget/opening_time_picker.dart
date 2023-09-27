import 'package:app_admin_pizzeria/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpeningTime extends StatelessWidget {
  const OpeningTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () async {
                final openingTime = await showTimePicker(
                  initialEntryMode: TimePickerEntryMode.inputOnly,
                  cancelText: "Cancella",
                  confirmText: "Conferma",
                  hourLabelText: "Ora",
                  minuteLabelText: "Minuti",
                  errorInvalidText: "Inserisci un orario valido",
                  helpText: "Inserisci l'orario di apertura",
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (context, childWidget) {
                    return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(alwaysUse24HourFormat: true),
                        child: childWidget!);
                  },
                );
                if (openingTime == null) {
                } else {
                  if (context.mounted) {
                    Provider.of<OrdersProvider>(context, listen: false)
                        .setTime(context, openingTime, null);
                  }
                }
              },
              child: const Text("Seleziona orario di apertura"),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () async {
                final closingTime = await showTimePicker(
                    initialEntryMode: TimePickerEntryMode.inputOnly,
                    cancelText: "Cancella",
                    confirmText: "Conferma",
                    hourLabelText: "Ora",
                    minuteLabelText: "Minuti",
                    errorInvalidText: "Inserisci un orario valido",
                    helpText: "Inserisci l'orario di chiusura",
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, childWidget) {
                      return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: childWidget!);
                    });
                if (closingTime == null) {
                } else {
                  if (context.mounted) {
                    Provider.of<OrdersProvider>(context, listen: false)
                        .setTime(context, null, closingTime);
                  }
                }
              },
              child: const Text("Seleziona orario di chiusura"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (Provider.of<OrdersProvider>(context).openingTime == "" ||
            Provider.of<OrdersProvider>(context).closingTime == "")
          Text("Orario non settato",
              style: Theme.of(context).textTheme.titleLarge)
        else
          Text(
              "Orario: ${Provider.of<OrdersProvider>(context).openingTime} - ${Provider.of<OrdersProvider>(context).closingTime}",
              style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
