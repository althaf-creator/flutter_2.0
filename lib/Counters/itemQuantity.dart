import 'package:flutter/foundation.dart';

class itemQuantity extends ChangeNotifier {
  int _numberOfItems = 0;

  int get numberOfItmes => _numberOfItems;

  display(int no) {
    _numberOfItems = no;
    notifyListeners();
  }
}
