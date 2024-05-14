import 'package:flutter/material.dart';
class BackGroundProvider extends ChangeNotifier {
  String text = "Ok";
  Color color = Colors.red;

  void setColor(Color c) {
    color = c;
    notifyListeners();
  }

  void changeText() {
    if (text == "!ok") {
      text = "Ok";
    } else {
      text = "!ok";
    }
    notifyListeners();
  }

  void changeColor() {
    if (color == Colors.red) {
      color = Colors.green;
    } else {
      color = Colors.red;
    }
    notifyListeners();
  }
}