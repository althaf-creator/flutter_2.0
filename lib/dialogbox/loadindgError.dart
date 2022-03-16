import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoadingErrordialog extends StatelessWidget {
  final String message;

  const LoadingErrordialog({Key key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text(message)
        ],
      ),
    );
  }
}
