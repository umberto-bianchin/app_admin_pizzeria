import 'package:flutter/material.dart';

class PageProvider with ChangeNotifier {
  int selectedPage = 0;
  String page = "Dashboard";

  String get getPage => page;

  void changePage(int page) {
    selectedPage = page;

    switch (page) {
      case 0:
        this.page = "Dashboard";
      case 1:
        this.page = "Mappa";
      case 2:
        this.page = "Menù";
      case 3:
        this.page = "Ordini";
    }
    notifyListeners();
  }
}
