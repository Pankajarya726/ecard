import 'package:flutter/cupertino.dart';

class CurrencySwitchProvider with ChangeNotifier {
  String currencyName = "qar";
  void changeCurrency(String name) {
    currencyName = name;
    notifyListeners();
  }
}
