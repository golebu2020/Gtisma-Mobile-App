import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gtisma/helpers/GlobalVariables.dart';
import 'package:gtisma/helpers/NavigationPreferences.dart';


class WalkThrough extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IntroViews Flutter', //title of app
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), //ThemeData
      home:Scaffold(body: Center(child: Text('good'))),
    ); //Material App
  }
}

