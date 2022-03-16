import 'package:flutter/material.dart';
import 'package:plant_app_v2_0/Authentication/login.dart';
import 'package:plant_app_v2_0/Authentication/register.dart';

class Authentication extends StatefulWidget {
  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            style: TextStyle(fontSize: 55.0, color: Colors.white),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                text: "Login",
              ),
              Tab(
                icon: Icon(
                  Icons.perm_contact_calendar,
                  color: Colors.white,
                ),
                text: "Register",
              ),
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
            colors: [Colors.green, Colors.greenAccent],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )),
          child: TabBarView(children: [
            login(),
            regsiter(),
          ]),
        ),
      ),
    );
  }
}
