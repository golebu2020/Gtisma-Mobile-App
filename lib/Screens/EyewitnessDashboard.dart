import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/CustomViews/MyDrawer.dart';
import 'package:gtisma/dashboardComponents/MakeAPictureDashboard.dart';
import 'package:gtisma/dashboardComponents/MakeATextDashboard.dart';
import 'package:gtisma/dashboardComponents/MakeAVideoDashboard.dart';
import 'package:gtisma/dashboardComponents/MyReportsDashboard.dart';
import 'package:gtisma/dashboardComponents/SelectCrimeTypes.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:gtisma/helpers/GlobalVariables.dart';
import 'package:gtisma/models/UserReport.dart';
import 'EyewitnessLogin.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

SelectLanguage lang = SelectLanguage();
dynamic nativeLanguage = '';

class EyewitnessDashboard extends StatelessWidget {
  EyewitnessDashboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Eye witness Reports",
      home: Scaffold(
        body: EyewitnessBody(),
      ),
    );
  }
}

class EyewitnessBody extends StatefulWidget {
  @override
  EyewitnessBodyState createState() => EyewitnessBodyState();
}

class EyewitnessBodyState extends State<EyewitnessBody> {
  String bearer;

  void initState() {
    bearer = UserPreferences().retrieveUserData();
    _getCrimes();
    super.initState();
  }

//Future<List<Reports>>
  static const String reportUrl = 'https://www.geotiscm.org/api/reports';
  _getCrimes() async {
    var response = await http.get(
      Uri.encodeFull(reportUrl),
      headers: {
        //HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $bearer",
        'Accept': 'application/json',
        'clientid': 'mobileclientpqqh6ebizhTecUpfb0qA',
      },
    );
    var jsonMe = json.decode(response.body);
   debugPrint(jsonMe.toString());
    // var jsonData = jsonMe['data'];
    // List<Reports> crimes = [];
    // for (var u in jsonData) {
    //   Crime crime = Crime(u['id'], u['name'], u['created_at'], u['updated_at']);
    //   crimes.add(crime);
    //   //crimeTypeSelection.add(false);
    // }
    // crimeTypeSelection = List<bool>.filled(crimes.length, false);
    // print(crimes.length);
    // print('Thanks');
    // return crimes;
  }

  moveToChangeLanguage() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          child: Text('Read Report'),
          onPressed: () {
            _getCrimes();
          },
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
