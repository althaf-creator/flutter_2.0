import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_app_v2_0/Storehome/Storehome.dart';
import 'package:plant_app_v2_0/Widgets/customtextfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_app_v2_0/config/config.dart';
import 'package:plant_app_v2_0/dialogbox/errorDialog.dart';
import 'package:plant_app_v2_0/dialogbox/loadindgError.dart';
import 'package:firebase_storage/firebase_storage.dart';

class regsiter extends StatefulWidget {
  @override
  State<regsiter> createState() => _regsiterState();
}

class _regsiterState extends State<regsiter> {
  final TextEditingController _nameeditingController = TextEditingController();
  final TextEditingController _maileditingController = TextEditingController();
  final TextEditingController _passeditingController = TextEditingController();
  final TextEditingController _cpasseditingController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String imageUrl = "";
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenwidth = MediaQuery.of(context).size.width;
    double _screenheight = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              onTap: _SelectandPickimage,
              child: CircleAvatar(
                radius: _screenwidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage:
                    _imageFile == null ? null : FileImage(_imageFile),
                child: _imageFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenwidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Customtextfield(
                    controller: _nameeditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
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
                  Customtextfield(
                    controller: _cpasseditingController,
                    data: Icons.lock,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                uploadandsaveimage();
              },
              color: Colors.grey,
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: 4.0,
              width: _screenwidth * 0.8,
              color: Colors.redAccent,
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _SelectandPickimage() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadandsaveimage() async {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Please Select an image file",
            );
          });
    } else {
      _passeditingController.text == _cpasseditingController.text
          ? _maileditingController.text.isNotEmpty &&
                  _passeditingController.text.isNotEmpty &&
                  _cpasseditingController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog("Please fill up the registartion form")
          : displayDialog("Password do not match");
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingErrordialog(
            message: "Register, please wait....",
          );
        });

    String imagefilename = DateTime.now().millisecondsSinceEpoch.toString();

    StorageReference storageReference = FirebaseStorage.instance.ref().child(imagefilename);

    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);

    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;

    await storageTaskSnapshot.ref.getDownloadURL().then((urlImage) {
      imageUrl = urlImage;

      _registerUser();
    });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;

    await _auth
        .createUserWithEmailAndPassword(
      email: _maileditingController.text.trim(),
      password: _passeditingController.text.trim(),
    ).then((auth) {firebaseUser = auth.user;
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
      saveUserInfotoFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => Storehome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfotoFireStore(FirebaseUser fuser) async {
    Firestore.instance.collection("users").document(fuser.uid).setData({
      "uid": fuser.uid,
      "email": fuser.email,
      "name": _nameeditingController.text.trim(),
      "url": imageUrl,
      Mcommerce.userCartList: ["garbageValue"],
    });

    await Mcommerce.sharedPreferences.setString(Mcommerce.userUID, fuser.uid);
    await Mcommerce.sharedPreferences.setString(Mcommerce.userEmail, fuser.email);
    await Mcommerce.sharedPreferences.setString(Mcommerce.userName, _nameeditingController.text.trim());
    await Mcommerce.sharedPreferences.setString(Mcommerce.userAvatarUrl, imageUrl);
    await Mcommerce.sharedPreferences.setStringList(Mcommerce.userCartList, ["garbageValue"]);
  }
}
