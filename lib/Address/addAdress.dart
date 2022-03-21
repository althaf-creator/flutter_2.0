import 'package:flutter/material.dart';
import 'package:plant_app_v2_0/Widgets/customAppbar.dart';
import 'package:plant_app_v2_0/models/addressModel.dart';
import 'package:plant_app_v2_0/config/config.dart';

class AddAdress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNumber.text,
                flatNumber: cFlatHomeNumber.text,
                city: cCity.text.trim(),
              ).toJson();

              // add to fireStore

              Mcommerce.firestore
                  .collection(Mcommerce.collectionUser)
                  .document(
                      Mcommerce.sharedPreferences.getString(Mcommerce.userUID))
                  .collection(Mcommerce.subCollectionAddress)
                  .document(DateTime.now().millisecondsSinceEpoch.toString())
                  .setData(model)
                  .then((value) {
                final snack =
                    SnackBar(content: Text("New Address Added Succesfully"));
                scaffoldKey.currentState.showSnackBar(snack);
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });
            }
          },
          label: Text("Done"),
          backgroundColor: Colors.redAccent,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add a new Adress",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    children: [
                      MyTextField(
                        hint: "Name",
                        controller: cName,
                      ),
                      MyTextField(
                        hint: "Phone Number",
                        controller: cPhoneNumber,
                      ),
                      MyTextField(
                        hint: "Flat / House Number",
                        controller: cFlatHomeNumber,
                      ),
                      MyTextField(
                        hint: "City",
                        controller: cCity,
                      ),
                      MyTextField(
                        hint: "Country",
                        controller: cState,
                      ),
                      MyTextField(
                        hint: "Pin Code",
                        controller: cPinCode,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  MyTextField({Key key, this.hint, this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? "Field is cannot be empty." : null,
      ),
    );
  }
}
