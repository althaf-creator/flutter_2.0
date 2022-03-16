import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_app_v2_0/Admin/adminsigninpage.dart';
import 'package:plant_app_v2_0/Storehome/Storehome.dart';
import 'package:plant_app_v2_0/Widgets/customtextfield.dart';
import 'package:plant_app_v2_0/config/config.dart';
import 'package:plant_app_v2_0/dialogbox/errorDialog.dart';
import 'package:plant_app_v2_0/dialogbox/loadindgError.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _maileditingController = TextEditingController();
  final TextEditingController _passeditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width;
    double _screenheight = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
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
                "Log in to your account",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Customtextfield(
                    controller: _maileditingController,
                    data: Icons.mail,
                    hintText: "Mail",
                    isObsecure: false,
                  ),
                  Customtextfield(
                    controller: _passeditingController,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                _maileditingController.text.isNotEmpty &&
                        _passeditingController.text.isNotEmpty
                    ? loginUser()
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
                  MaterialPageRoute(builder: (context) => AdminSignIn())),
              icon: (Icon(
                Icons.nature_people,
                color: Colors.blueGrey,
              )),
              label: Text(
                "I am Admin",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingErrordialog(
            message: "Authenticating, please wait...",
          );
        });
    FirebaseUser firebaseUser;

    await _auth
        .signInWithEmailAndPassword(
      email: _maileditingController.text.trim(),
      password: _passeditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => Storehome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection("user")
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await Mcommerce.sharedPreferences
          .setString(Mcommerce.userUID, dataSnapshot.data[Mcommerce.userUID]);

      await Mcommerce.sharedPreferences.setString(
          Mcommerce.userEmail, dataSnapshot.data[Mcommerce.userEmail]);

      await Mcommerce.sharedPreferences
          .setString(Mcommerce.userName, dataSnapshot.data[Mcommerce.userName]);

      await Mcommerce.sharedPreferences.setString(
          Mcommerce.userAvatarUrl, dataSnapshot.data[Mcommerce.userAvatarUrl]);

      List<String> carList =
          dataSnapshot.data[Mcommerce.userCartList].cast<String>();
      await Mcommerce.sharedPreferences
          .setStringList(Mcommerce.userCartList, carList);
    });
  }
}
