import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PickLang extends StatefulWidget {
  @override
  _PickLangState createState() => _PickLangState();
}

class _PickLangState extends State<PickLang> {
  convertImage() async {
    http.Response response = await http.get(
      'https://cdn.pixabay.com/photo/2020/09/23/14/38/woman-5596173_960_720.jpg',
    );
print(response.bodyBytes);
    var _base64 = base64Encode(response.bodyBytes);

    print(_base64);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: RaisedButton(
              child: Text('Convert Image'),
              onPressed: () {
                convertImage();
              },
            ),
          ),
        ),
      ),
    );
  }
}
