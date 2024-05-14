import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CounterProvider extends ChangeNotifier {
  int _counter = 100;

  int get counter => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }
}
