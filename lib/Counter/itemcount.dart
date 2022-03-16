import 'package:flutter/foundation.dart';
import 'package:plant_app_v2_0/config/config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter =
      Mcommerce.sharedPreferences.getStringList(Mcommerce.userCartList).length -
          1;
  int get count => _counter;
}
