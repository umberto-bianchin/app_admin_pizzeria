import 'package:app_admin_pizzeria/data/order_data.dart';
import 'package:app_admin_pizzeria/widget/my_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/data_item.dart';
import 'data/menu_items_list.dart';
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

  //FirebaseAuth.instance.setPersistence(Persistence.LOCAL)

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

    //saveAdmin();
    if (context.mounted) {
      Provider.of<PageProvider>(context, listen: false)
          .changeStatus(LoginStatus.logged);
    }
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

void saveUserInfos({required String address, required String phone}) {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  firestoreInstance
      .collection("users")
      .doc(firebaseUser!.uid)
      .collection("infos")
      .doc("information")
      .set({
    "address": address,
    "phone": phone,
  }, SetOptions(merge: true));
}

void saveAdmin() {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  firestoreInstance.collection("access").doc(firebaseUser!.uid).set({
    'admin': true,
  }, SetOptions(merge: true));
}

Future<Map<String, String>> getUserInfo() async {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  var snapshot = await firestoreInstance
      .collection("users")
      .doc(firebaseUser!.uid)
      .collection("infos")
      .doc("information")
      .get();

  if (snapshot.exists) {
    return {
      "address": snapshot.data()!["address"],
      "phone": snapshot.data()!["phone"],
    };
  }
  return {
    "address": "",
    "phone": "",
  };
}

String getUserMail() {
  return FirebaseAuth.instance.currentUser!.email!;
}

OrderData retrieveOrderUser(
  BuildContext context,
  Map<String, dynamic> data,
) {
  List<DataItem> itemsList = [];

  // Iterate through fields with "ordine" prefix
  int orderIndex = 0;
  while (data.containsKey('ordine$orderIndex')) {
    final Map<String, dynamic> field = data['ordine$orderIndex'];
    itemsList.add(DataItem(
        key: UniqueKey(),
        image: information[field["name"]]![2],
        name: field["name"],
        ingredients: getIngredients(field["ingredients"]),
        initialPrice: information[field["name"]]![0],
        category: information[field["name"]]![1],
        quantity: field["quantity"]));

    orderIndex++;
  }

  return OrderData(
      data: itemsList,
      accepted: data["accepted"],
      deliveryMethod: data["delivery-method"],
      time: data["time-interval"],
      price: data["total"]);
}

Future<List<OrderData>> retrieveOrders(BuildContext context) async {
  final snapshot = await FirebaseFirestore.instance.collection('users').get();
  final allUserDocuments = snapshot.docs;

  List<OrderData> ordersList = [];
  for (final userDoc in allUserDocuments) {
    final userOrder =
        await userDoc.reference.collection('orders').doc("order").get();

    if (context.mounted) {
      ordersList.add(
        retrieveOrderUser(
          context,
          userOrder.data()!,
        ),
      );
    }
  }

  return ordersList;
}

List<Ingredients> getIngredients(String ingredients) {
  List<String> ingr = ingredients.split(', ');
  return ingr
      .map((ingred) => Ingredients.values
          .firstWhere((e) => e.toString() == 'Ingredients.$ingred'))
      .toList();
}

void confirmOrder(String uid) {
  firestoreInstance
      .collection("users")
      .doc(uid)
      .collection("orders")
      .doc("order")
      .set({
    "accepted": "True",
  }, SetOptions(merge: true));
}
