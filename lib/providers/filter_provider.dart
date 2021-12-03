import 'package:flutter/cupertino.dart';

class FilterProvider with ChangeNotifier {
  int selectedID = 0;
  double low = 0.0;
  double high = 0.0;
  String keyword = '';

  makeNormal() {
    selectedID = 0;
    low = 0.0;
    high = 0.0;
    keyword = '';
  }

  changeID(int id) {
    selectedID = id;
    notifyListeners();
  }

  changeLowAndHigh({lowValue, highValue}) {
    low = lowValue;
    high = highValue;
    notifyListeners();
  }

  changeText(String value) {
    keyword = value;
    notifyListeners();
  }
}
