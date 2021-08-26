import 'package:flutter/material.dart';


class CustomButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color:Colors.red, width: 2.0),
          ),
        ),
    );
  }

}
