import 'package:flutter/material.dart';
import 'package:plant_app_v2_0/Counter/itemcount.dart';
import 'package:plant_app_v2_0/Storehome/cart.dart';
import 'package:plant_app_v2_0/Widgets/mydrawer.dart';
import 'package:provider/provider.dart';

class Storehome extends StatefulWidget {
  @override
  State<Storehome> createState() => _StorehomeState();
}

class _StorehomeState extends State<Storehome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
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
        title: Text(
          "M-commerce",
          style: TextStyle(fontSize: 30.0, color: Colors.white),
        ),
        centerTitle: true,
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
                      child: Consumer<CartItemCounter>(
                        builder: (context, counter, _) {
                          return Text(
                            counter.count.toString(),
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
      ),
      drawer: Mydrawer(),
    ));
  }
}
