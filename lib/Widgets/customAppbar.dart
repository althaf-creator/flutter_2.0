import 'package:flutter/material.dart';
import 'package:plant_app_v2_0/Storehome/cart.dart';
import 'package:provider/provider.dart';
import 'package:plant_app_v2_0/Counters/cartItemCounter.dart';
import 'package:plant_app_v2_0/config/config.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.green,
                  Colors.greenAccent,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp)),
      ),
      centerTitle: true,
      title: Text(
        "M-commerce",
        style: TextStyle(fontSize: 30.0, color: Colors.white),
      ),
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.redAccent,
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => Cartpage());
                Navigator.pushReplacement(context, route);
              },
            ),
            Positioned(
                child: Stack(
              children: [
                Icon(
                  Icons.brightness_1,
                  size: 20.0,
                  color: Colors.green,
                ),
                Positioned(
                    top: 3.0,
                    bottom: 4.0,
                    left: 4.0,
                    child: Consumer<CartItemCounter>(
                      builder: (context, counter, _) {
                        return Text(
                          (Mcommerce.sharedPreferences
                                      .getStringList(Mcommerce.userCartList)
                                      .length -
                                  1)
                              .toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500),
                        );
                      },
                    ))
              ],
            ))
          ],
        ),
      ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
