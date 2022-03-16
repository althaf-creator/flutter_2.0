import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plant_app_v2_0/Admin/uploaditems.dart';
import 'package:plant_app_v2_0/Authentication/authentication.dart';
import 'package:plant_app_v2_0/Widgets/customtextfield.dart';
import 'package:plant_app_v2_0/dialogbox/errorDialog.dart';

class AdminSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: AdminSignInScrenn(),
    );
  }
}

class AdminSignInScrenn extends StatefulWidget {
  @override
  State<AdminSignInScrenn> createState() => _AdminSignInScrennState();
}

class _AdminSignInScrennState extends State<AdminSignInScrenn> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _admineditingController = TextEditingController();
  final TextEditingController _passwordeditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width;
    double _screenheight = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Colors.green,
                Colors.greenAccent,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Image.asset(
                "assets/images/plant1.jpg",
                height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Admin",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Customtextfield(
                    controller: _admineditingController,
                    data: Icons.person,
                    hintText: "id",
                    isObsecure: false,
                  ),
                  Customtextfield(
                    controller: _passwordeditingController,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                _admineditingController.text.isNotEmpty &&
                        _passwordeditingController.text.isNotEmpty
                    ? loginAdmin()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(
                            message: "Please write email and password",
                          );
                        });
              },
              color: Colors.grey,
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0,
              width: _screenwidth * 0.8,
              color: Colors.redAccent,
            ),
            SizedBox(
              height: 50.0,
            ),
            FlatButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Authentication())),
              icon: (Icon(
                Icons.nature_people,
                color: Colors.blueGrey,
              )),
              label: Text(
                "I am not Admin",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    Firestore.instance.collection("admins").getDocuments().then((snapshot) {
      snapshot.documents.forEach((results) {
        if (results.data["id"] != _admineditingController.text.trim()) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("Your id is incorrect")));
        } else if (results.data["password"] !=
            _passwordeditingController.text.trim()) {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("Your password is incorrect")));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Welcome Admin" + results.data["name"]),
          ));
          setState(() {
            _admineditingController.text = "";
            _passwordeditingController.text = "";
          });
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
