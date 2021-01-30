import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
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

class EyewitnessBodyState extends State<EyewitnessBody> with TickerProviderStateMixin{
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
      backgroundColor: Colors.black.withOpacity(0.04),
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
  List<String> pictureList=[];
  List<String> status=[];
  //List<List<dynamic>> pictureListOfList = [];
  List<dynamic> list3 = [];
  List<String> pictureList2 = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRnltfxyRHuEEUE4gIZp9fr77Q8goigP7mQ6Q&usqp=CAU",
    "https://imageproxy.themaven.net//https%3A%2F%2Fwww.history.com%2F.image%2FMTY1MTc3MjE0MzExMDgxNTQ1%2Ftopic-golden-gate-bridge-gettyimages-177770941.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-fff2lftqIE077pFAKU1Mhbcj8YFvBbMvpA&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRU2U6QAHfoDaofFbNo4OLtaqYWzihF5d4fhw&usqp=CAU"];

  List<double> locationContainerWidth = [];
  List<double> statusContainerWidth = [];
  List<double> addressWidth = [];
  List<double> addressHeight = [];
  List<bool> addressShowing = [];
  List<double> addressPosition = [];
  List<double> addressOpacity = [];
  List<int> _current = [];

  List<dynamic> listItemsGetter(ReportsData reportsData) {

    reportsData.reports.forEach((value) {
      //The Animation of Containers
      locationContainerWidth.add(0.0);
      statusContainerWidth.add(0.0);
      addressWidth.add(0.0);
      addressHeight.add(0.0);
      addressShowing.add(false);
      addressPosition.add(300.0);
      addressOpacity.add(0.0);
      _current.add(0);

      //The actual values
      firstName.add(value['user']['first_name']);
      lastName.add(value['user']['last_name']);
      email.add(value['user']['email']);
      avatar.add(value['user']['picture_url']);
      time.add(value['user']['created_at']);
      description.add(value['description']);
      var lat = value['location'];
      latitude.add('7.2630339');
      longitude.add('7.2630339');
      //latitude.add(lat.substring(0, 8));
      //longitude.add(lat.substring(10, 18));
      address.add(value['address']);
      status.add(value['status']);
    });
    list3.addAll({firstName,lastName,email,avatar,time,description,latitude,longitude,address,status});
    return list3;
  }

  Widget listItemBuilder(value, int index) {
    return Wrap(
      children: [
        Card(
          margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 1.0,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage:
                          AssetImage('assets/images/avater_design.png'),
                          radius: 20.0,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage:
                          NetworkImage(avatar[index]),
                          radius: 20.0,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(firstName[index] + ' ' + lastName[index],
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15.0,
                                color: Colors.black,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(email[index],
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.0,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 74.0, top: 25.0),
                      child: Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 20.0),
                          Text('10.50pm',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black.withAlpha(190),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 15.0),
                      color: Colors.white,
                      width: double.infinity,
                      child: Text(description[index],
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                    ),
                    Stack(
                      children: [
                        Visibility(
                          visible: pictureList2.isNotEmpty?true:false,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 75.0,
                                left: 160.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.purple),
                                  backgroundColor: Colors.blueAccent,
                                ),
                              ),
                              CarouselSlider(
                                //options: CarouselOptions(height: 400.0),
                                options: CarouselOptions(
                                  disableCenter: false,
                                  height: 220.0,
                                  enableInfiniteScroll: false,
                                  viewportFraction: 1.0,
                                  reverse: false,
                                  autoPlay: false,
                                  autoPlayInterval: Duration(seconds: 3),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (myIndex, reason) {
                                    setState(() {
                                      _current[index] = myIndex;
                                    });
                                  },
                                ),

                                items: pictureList2.map((e) => Container(
                                  child: Image.network(e,
                                    height: 250.0,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ))
                                    .toList(),
                              ),
                              Positioned(
                                top: 190.0,
                                left: 140.0,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: pictureList2.map((url) {
                                    int myIndex = pictureList2.indexOf(url);
                                    return Container(
                                      width: 8.0,
                                      height: 8.0,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 2.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _current[index] == myIndex
                                            ? Color.fromRGBO(
                                            255, 255, 255, 0.8)
                                            : Color.fromRGBO(0, 0, 0, 0.8),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 1000),
                                  opacity: addressOpacity[index],
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: AnimatedContainer(
                                    transform: Matrix4.translationValues(
                                        0.0, addressPosition[index], 0.0),
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    padding: EdgeInsets.all(10.0),
                                    height: addressHeight[index],
                                    width: addressWidth[index],
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(20.0),
                                      color: Colors.white,
                                    ),
                                    child: Text(address[index],
                                      softWrap: false,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Stack(
                      children: [
                        Positioned(
                          left: 100.0,
                          top: 1.0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.fastLinearToSlowEaseIn,
                            color: Colors.white,
                            height: 50.0,
                            width: locationContainerWidth[index],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Latitude: ${latitude[index]}\nLongitude: ${longitude[index]}',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: AnimatedContainer(
                              onEnd: () {},
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn,
                              color: Colors.white,
                              height: 35.0,
                              width: statusContainerWidth[index],
                              child: RaisedButton(
                                shape: StadiumBorder(),
                                color: Colors.pinkAccent,//Color.fromRGBO(120, 78, 125, 1.0),
                                onPressed: () {
                                  debugPrint('Activate $index');
                                },
                                child: Text(status[index]+'...',
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  statusContainerWidth[index] = 0.0;
                                  locationContainerWidth[index] = 200.0;
                                  addressHeight[index] = 40.0;
                                  addressWidth[index] = 250;
                                  addressPosition[index] = 190.0;
                                  addressOpacity[index] = 1.0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.0),
                                  color: Color.fromRGBO(120, 78, 125, 1.0),
                                ),
                                child: Icon(Icons.location_on,
                                    color: Colors.white),
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  statusContainerWidth[index] = 100.0;
                                  locationContainerWidth[index] = 0.0;
                                  addressHeight[index] = 0.0;
                                  addressWidth[index] = 0.0;
                                  addressPosition[index]= 300.0;
                                  addressOpacity[index] = 0.0;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.0),
                                  color: Color.fromRGBO(120, 78, 125, 1.0),
                                ),
                                child: Icon(
                                  Icons.adjust,
                                  color: Colors.white,
                                ),
                                width: 40.0,
                                height: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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