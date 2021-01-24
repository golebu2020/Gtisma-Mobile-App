import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/models/CrimeTypes.dart';
import 'package:gtisma/models/States.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'WriteReport.dart';
import 'ChooseCrime.dart';
import 'ChooseNationalState.dart';
import 'SendReport.dart';

class Pop extends StatelessWidget {
  PageController pageController;
  Function trigger;
  Function nextPage;
  int nextPageIndex;
  Function retrieveJSON;
  Pop(
      {Key key,
      @required this.pageController,
      @required this.trigger,
      @required this.nextPage,
      @required this.nextPageIndex,
      this.retrieveJSON})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 10.0,
        shadowColor: Colors.black,
        color: Colors.transparent,
        //shape: StadiumBorder(),
        child: Container(
          margin: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(120, 78, 125, 1.0),
                Color.fromRGBO(41, 78, 149, 1.0)
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(80.0),
              topRight: const Radius.circular(80.0),
              bottomLeft: const Radius.circular(10.0),
              bottomRight: const Radius.circular(10.0),
            ),
          ),
          child: PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              WriteReport(trigger: trigger, nextPage: nextPage),
              ChooseCrime(trigger, nextPage),
              ChooseNational(trigger, nextPage),
              SendReport(retrieveJSON: retrieveJSON, trigger: trigger, nextPage: nextPage),
            ],
          ),
          height: double.infinity,
          width: double.infinity,
        ),
      ),
    );
  }
}
