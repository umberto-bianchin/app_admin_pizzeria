import 'package:flutter/material.dart';

enum LoginStatus { notLogged, logged }

class PageProvider with ChangeNotifier {
  LoginStatus loginStatus = LoginStatus.notLogged;
  int selectedPage = 0;
  String page = "Dashboard";

  String get getPage => page;

  void changeStatus(LoginStatus status) {
    loginStatus = status;
    notifyListeners();
  }

  void changePage(int page) {
    selectedPage = page;

    switch (page) {
      case 0:
        this.page = "Dashboard";
      case 1:
        this.page = "Mappa";
      case 2:
        this.page = "Menu";
      case 3:
        this.page = "Ordini";
    }
    notifyListeners();
  }
}
