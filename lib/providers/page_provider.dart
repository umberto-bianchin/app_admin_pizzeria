import 'package:app_admin_pizzeria/widget/menu_widget/categories_buttons_tab.dart';
import 'package:flutter/material.dart';

enum LoginStatus { notLogged, logged }

class PageProvider with ChangeNotifier {
  LoginStatus loginStatus = LoginStatus.notLogged;
  int selectedPage = 0;
  Categories selectedCategory = Categories.pizze;
  String page = "Ordini";

  String get getPage => page;

  void changeStatus(LoginStatus status) {
    loginStatus = status;
    notifyListeners();
  }

  void changeCategory(Categories category) {
    selectedCategory = category;
    notifyListeners();
  }

  void changePage(int page) {
    selectedPage = page;

    switch (page) {
      case 0:
        this.page = "Ordini";
      case 1:
        this.page = "Mappa";
      case 2:
        this.page = "Menu";
    }
    notifyListeners();
  }
}
