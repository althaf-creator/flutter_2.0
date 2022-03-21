import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plant_app_v2_0/Address/address.dart';
import 'package:plant_app_v2_0/Storehome/Storehome.dart';
import 'package:plant_app_v2_0/Widgets/customAppbar.dart';
import 'package:plant_app_v2_0/Widgets/loadingwidget.dart';
import 'package:plant_app_v2_0/Widgets/mydrawer.dart';
import 'package:plant_app_v2_0/config/config.dart';
import 'package:plant_app_v2_0/models/items.dart';
import 'package:provider/provider.dart';
import 'package:plant_app_v2_0/Counters/totalMoney.dart';
import 'package:plant_app_v2_0/Counters/cartItemCounter.dart';

class Cartpage extends StatefulWidget {
  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  double totalAmount;
  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (Mcommerce.sharedPreferences
                  .getStringList(Mcommerce.userCartList)
                  .length ==
              1) {
            Fluttertoast.showToast(msg: "your cart is empty");
          } else {
            Route route = MaterialPageRoute(
                builder: (c) => Address(totalAmount: totalAmount));
            Navigator.pushReplacement(context, route);
          }
        },
        label: Text("Check Out"),
        backgroundColor: Colors.purpleAccent,
        icon: Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      drawer: Mydrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
                builder: (context, amountProvider, cartProvider, c) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Text(
                            "Total Price: Rs ${amountProvider.totalAmount.toString()}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500),
                          )),
              );
            }),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Mcommerce.firestore
                .collection("items")
                .where("shortInfo",
                    whereIn: Mcommerce.sharedPreferences
                        .getStringList(Mcommerce.userCartList))
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgress(),
                      ),
                    )
                  : snapshot.data.documents.length == 0
                      ? beginbuildingCart()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ItemModel model = ItemModel.FromJson(
                                  snapshot.data.documents[index].data);

                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = model.price + totalAmount;
                              } else {
                                totalAmount = model.price + totalAmount;
                              }
                              if (snapshot.data.documents.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((t) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .display(totalAmount);
                                });
                              }
                              return sourceInfo(model, context,
                                  removeCartFunction: () =>
                                      removeitemformusercart(model.shortInfo));
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data.documents.length
                                : 0,
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }

  beginbuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.insert_emoticon,
                color: Colors.white,
              ),
              Text("Card is empty."),
              Text("Start adding items to your card."),
            ],
          ),
        ),
      ),
    );
  }

  removeitemformusercart(String shortInfoAsId) {
    List tempCartList =
        Mcommerce.sharedPreferences.getStringList(Mcommerce.userCartList);
    tempCartList.remove(shortInfoAsId);

    Mcommerce.firestore
        .collection(Mcommerce.collectionUser)
        .document(Mcommerce.sharedPreferences.getString(Mcommerce.userUID))
        .updateData({
      Mcommerce.userCartList: tempCartList,
    }).then((v) {
      Fluttertoast.showToast(msg: "Item removed Succesfully");
      Mcommerce.sharedPreferences
          .setStringList(Mcommerce.userCartList, tempCartList);

      Provider.of<CartItemCounter>(context, listen: false).displayResult();

      totalAmount = 0;
    });
  }
}
