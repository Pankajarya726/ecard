import 'package:flutter/cupertino.dart';

class BottomNavigationBarProvider with ChangeNotifier {
  int index = 0;

  changeIndex(int i) {
    index = i;
    notifyListeners();
  }
}
