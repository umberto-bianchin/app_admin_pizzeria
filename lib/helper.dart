import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final firestoreInstance = FirebaseFirestore.instance;

void logOut(BuildContext ctx) {
  FirebaseAuth.instance.signOut();
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
