import 'package:flutter/material.dart';

class AdminConfirmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Admin Confirm Page",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Confirm Incident"),
          backgroundColor: Color.fromRGBO(120, 78, 125, 1.0),
        ),
        body: AdminBody(),
      ),
    );
  }
}

class AdminBody extends StatefulWidget {
  @override
  _AdminBodyState createState() => _AdminBodyState();
}

class _AdminBodyState extends State<AdminBody> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}



