import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_paginator/enums.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
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
import 'DashboardItems.dart';
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
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
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
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  void initState() {
    bearer = UserPreferences().retrieveUserData();
    super.initState();
  }

  moveToChangeLanguage() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Paginator.listView(
        key: paginatorGlobalKey,
        pageLoadFuture: sendCountriesDataRequest,
        pageItemsGetter: listItemsGetter,
        listItemBuilder: listItemBuilder,
        loadingWidgetBuilder: loadingWidgetMaker,
        errorWidgetBuilder: errorWidgetMaker,
        emptyListWidgetBuilder: emptyListWidgetMaker,
        totalItemsGetter: totalPagesGetter,
        pageErrorChecker: pageErrorChecker,
        scrollPhysics: BouncingScrollPhysics(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        heroTag: Text('downloadReport'),
        onPressed: () {
          paginatorGlobalKey.currentState.changeState(
              pageLoadFuture: sendCountriesDataRequest, resetState: true);
        },
        child: Icon(Icons.refresh),
      ),
    );
  }

  Future<ReportsData> sendCountriesDataRequest(int page) async {

    try {
        String url = Uri.encodeFull(
        'https://www.geotiscm.org/api/reports?page=$page');
        var response = await http.get(url,
        headers: {
        //HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $bearer",
        'Accept': 'application/json',
        'clientid': 'mobileclientpqqh6ebizhTecUpfb0qA',
        });
        debugPrint(response.body);
      return ReportsData.fromResponse(response);
    } catch (e) {
      if (e is IOException) {
        return ReportsData.withError(
            'Please check your internet connection.');
      } else {
        print(e.toString());
        return ReportsData.withError('Something went wrong.');
      }
    }
  }

  List<String> firstName = [];
  List<String> lastName = [];
  List<String> email = [];
  List<String> avatar = [];
  List<String> time = [];
  List<String> description = [];
  List<String> latitude=[];
  List<String> longitude=[];
  List<String> address=[];
  List<dynamic> pictureList=[];
  List<String> status=[];
  List<List<String>> pictureListOfList = [];
  List<dynamic> list3 = [];

  List<dynamic> listItemsGetter(ReportsData reportsData) {

    reportsData.reports.forEach((value) {
      firstName.add(value['user']['first_name']);
      lastName.add(value['user']['last_name']);
      email.add(value['user']['email']);
      avatar.add(value['user']['picture_url']);
      time.add(value['user']['created_at']);
      description.add(value['description']);
      var lat = value['location'];
      latitude.add(lat.substring(0, 8));
      longitude.add(lat.substring(10, 18));
      address.add(value['address']);
      status.add(value['status']);
      var reportContent = value['reportcontent'];
      for(var content in reportContent){
        pictureList.add(content['file_url']);
      }
      pictureListOfList.add(pictureList);
    });

    return list3;
  }

  Widget listItemBuilder(value, int index) {
    return DashboardItems(
      address: address[index],
      description: description[index],
      email: email[index],
      firstName: firstName[index],
      lastName: lastName[index],
      latitude: latitude[index],
      longitude: longitude[index],
      status: status[index],
      time: time[index],
      avatar: avatar[index],
      pictureList: pictureListOfList,
    );
  }

  Widget loadingWidgetMaker() {
    return Container(
      alignment: Alignment.center,
      height: 160.0,
      child: SizedBox(
        width: 50.0,
        height: 50.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color> (Colors.purple),
          backgroundColor: Colors.blueAccent,
          strokeWidth: 5,
        ),
      ),
    );
  }

  Widget errorWidgetMaker(ReportsData reportsData, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0,right: 16.0, bottom: 10.0,),
          child: Opacity(opacity: 0.15,child: Image.asset('assets/images/checkNetwork.png', width: 200.0, height: 200.0,)),
        ),
        FlatButton(
          onPressed: retryListener,
          child: Opacity(
            opacity: 0.4,
            child: Text('Check your network \nconnection and retry',  style: GoogleFonts.fredokaOne(
                color: Colors.black, fontSize: 20.0,fontWeight: FontWeight.w200 ),),
          ),
        )
      ],
    );
  }

  Widget emptyListWidgetMaker(ReportsData reportsData) {
    return Center(
      child: Text('No countries in the list'),
    );
  }

  int totalPagesGetter(ReportsData reportsData) {
    return reportsData.total;
  }

  bool pageErrorChecker(ReportsData reportsData) {
    return reportsData.statusCode != 200;
  }
}

class ReportsData {
  List<dynamic> reports;
  int statusCode;
  String errorMessage;
  int total;
  int nItems;

  ReportsData.fromResponse(http.Response response) {
    this.statusCode = response.statusCode;
    var jsonData = json.decode(response.body);
   // var data = jsonData['data'];
    reports =  jsonData['data']['data'];
    total = jsonData['data']['total'];
    nItems = reports.length;
  }

  ReportsData.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}