import 'dart:async';

import 'package:app_admin_pizzeria/data/order_data.dart';
import 'package:app_admin_pizzeria/providers/menu_provider.dart';
import 'package:app_admin_pizzeria/providers/orders_provider.dart';
import 'package:app_admin_pizzeria/widget/categories_buttons_tab.dart';
import 'package:app_admin_pizzeria/widget/my_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/data_item.dart';
import 'main.dart';
import 'providers/page_provider.dart';

final firestoreInstance = FirebaseFirestore.instance;

Future signIn(
  BuildContext context,
  TextEditingController emailController,
  TextEditingController passwordController,
  GlobalKey<FormState> formKey,
) async {
  if (!formKey.currentState!.validate()) {
    MyDialog.showMyDialog(context,
        message: "Credenziali in forma errata", title: "Errore");
    return;
  }

  FocusScope.of(context).unfocus();

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      });

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());

    if (context.mounted) Navigator.pop(context);

    IdTokenResult idTokenResult =
        await FirebaseAuth.instance.currentUser!.getIdTokenResult();
    bool isAdmin = idTokenResult.claims!['admin'] ?? false;

    if (!isAdmin && context.mounted) {
      logOut(context);
      MyDialog.showMyDialog(context,
          message: "Non é un account admin", title: "Errore");
      emailController.clear();
      passwordController.clear();
      return;
    }

    if (context.mounted) {
      Provider.of<MenuProvider>(context, listen: false).retrieveMenu();
      Provider.of<MenuProvider>(context, listen: false).retrieveIngredients();
      Provider.of<PageProvider>(context, listen: false)
          .changeStatus(LoginStatus.logged);
    }
    //saveAdmin();
  } on FirebaseAuthException catch (e) {
    String error = e.code;

    if (error == 'user-not-found' || error == 'wrong-password') {
      error = "Credenziali errate";
    }

    if (!context.mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    MyDialog.showMyDialog(
      context,
      title: "Errore",
      message: error,
    );
  }
}

void logOut(BuildContext context) {
  FirebaseAuth.instance.signOut();
  Provider.of<PageProvider>(context, listen: false)
      .changeStatus(LoginStatus.notLogged);

  Provider.of<OrdersProvider>(context, listen: false).clearListener();
}

Future resetPassword(
    BuildContext context,
    TextEditingController backupEmailController,
    GlobalKey<FormState> resetKey) async {
  if (!resetKey.currentState!.validate()) {
    MyDialog.showMyDialog(context,
        message: "Credenziali in forma errata", title: "Errore");
    return;
  }

  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      });

  try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: backupEmailController.text.trim());

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      MyDialog.showMyDialog(context,
          message: 'Email inviata', title: "Conferma");
    }
  } on FirebaseAuthException catch (e) {
    String error = e.code;

    if (e.code == 'user-not-found') {
      error = "Nessun utente registrato con questa mail";
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    MyDialog.showMyDialog(context, message: error, title: "Errore");
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

String getUserMail() {
  return FirebaseAuth.instance.currentUser!.email!;
}

OrderData retrieveOrderUser(Map<String, dynamic> data, String name,
    String phone, String address, String uid, BuildContext context) {
  List<DataItem> itemsList = [];

  // Iterate through fields with "ordine" prefix
  int orderIndex = 0;
  while (data.containsKey('ordine$orderIndex')) {
    final Map<String, dynamic> field = data['ordine$orderIndex'];

    DataItem baseItem = Provider.of<MenuProvider>(context, listen: false)
        .menu
        .firstWhere((element) => element.name == field["name"]);

    itemsList.add(DataItem(
        key: UniqueKey(),
        image: baseItem.image,
        name: baseItem.name,
        ingredients: field["ingredients"].split(", "),
        initialPrice: baseItem.initialPrice,
        category: baseItem.category,
        quantity: field["quantity"]));

    orderIndex++;
  }

  return OrderData(
    data: itemsList,
    accepted: data["accepted"],
    deliveryMethod: data["delivery-method"],
    deliveryPrice: (data["delivery-price"] ?? 0.0).toDouble(),
    personalPrice: (data["price"] ?? 0.0).toDouble(),
    time: data["time-interval"],
    name: name,
    phone: phone,
    address: address,
    uid: uid,
  );
}

Future<List<OrderData>> retrieveOrders(BuildContext context) async {
  final snapshot = await FirebaseFirestore.instance.collection('users').get();
  final allUserDocuments = snapshot.docs;

  List<OrderData> ordersList = [];
  for (final userDoc in allUserDocuments) {
    String name = userDoc["name"];
    String phone = userDoc["phone"];
    String address = userDoc["address"];

    final userOrder =
        await userDoc.reference.collection('orders').doc("order").get();

    if (userOrder.exists && context.mounted) {
      ordersList.add(
        retrieveOrderUser(
            userOrder.data()!, name, phone, address, userDoc.id, context),
      );
    }
  }

  return ordersList;
}

/*Map<String, double> getIngredients(String ingredients, BuildContext context) {
  return {
    for (var e in ingredients.split(', '))
      e: Provider.of<MenuProvider>(context, listen: false).ingredients[e]!
  };
} */

void submitOrder(
  BuildContext ctx, {
  required OrderData order,
}) async {
  final Map<String, dynamic> jsonOrder = {};
  int index = 0;

  jsonOrder["accepted"] = "True";
  jsonOrder["time-interval"] = order.time;
  jsonOrder["delivery-price"] = order.deliveryPrice;
  jsonOrder["total"] = order.getTotal(ctx).toStringAsFixed(2);
  jsonOrder["price"] = order.personalPrice;
  jsonOrder["delivery-method"] = order.deliveryMethod;

  for (DataItem item in order.data) {
    jsonOrder["ordine$index"] = {
      "name": item.name,
      "quantity": item.quantity,
      "ingredients": item.ingredients.join(', '),
    };
    index++;
  }

  firestoreInstance
      .collection("users")
      .doc(order.uid)
      .collection("orders")
      .doc("order")
      .set(jsonOrder, SetOptions(merge: true));

  Provider.of<OrdersProvider>(ctx, listen: false).confirmOrder(order);

  final snapshot =
      await firestoreInstance.collection("users").doc(order.uid).get();

  String token = snapshot.data()!["token"];

  sendNotification("Ordine confermato", token);
}

void sendNotification(String title, String token) async {
  try {
    await FirebaseFunctions.instance.httpsCallable('sendNotification').call({
      "title": title,
      "token": token,
    });
  } catch (error) {
    if (kDebugMode) {
      print(error);
    }
  }
}

void saveMenu(List<DataItem> menu) {
  final Map<String, dynamic> jsonMenu = {};

  firestoreInstance.collection("menu").doc("elements").delete();

  for (DataItem item in menu) {
    jsonMenu[item.name] = {
      "price": item.initialPrice,
      "ingredients": item.ingredients.join(', '),
      "category": item.category.name,
    };
  }

  firestoreInstance
      .collection("menu")
      .doc("elements")
      .set(jsonMenu, SetOptions(merge: true));
}

Future<List<DataItem>> getMenu() async {
  final List<DataItem> menu = [];

  final snapshot =
      await FirebaseFirestore.instance.collection('menu').doc("elements").get();

  final menuData = snapshot.data();

  if (menuData != null) {
    for (String element in menuData.keys) {
      Categories category = Categories.values
          .firstWhere((value) => value.name == menuData[element]["category"]);

      menu.add(
        DataItem(
          key: UniqueKey(),
          name: element,
          ingredients: menuData[element]["ingredients"].split(", "),
          initialPrice: menuData[element]["price"],
          category: category,
          image: listCategories
              .firstWhere((element) => element.category == category)
              .icon,
        ),
      );
    }
  }

  return menu;
}

void saveIngredients(Map<String, double> ingredients) {
  firestoreInstance.collection("menu").doc("ingredients").delete();

  firestoreInstance
      .collection("menu")
      .doc("ingredients")
      .set(ingredients, SetOptions(merge: true));
}

Future<Map<String, double>> getSavedIngredients() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('menu')
      .doc("ingredients")
      .get();

  Map<String, double> ingredientsMap = {};
  if (snapshot.data() != null) {
    snapshot.data()!.forEach((key, value) {
      if (value is num) {
        ingredientsMap[key] = value.toDouble();
      }
    });
  }

  return ingredientsMap;
}
