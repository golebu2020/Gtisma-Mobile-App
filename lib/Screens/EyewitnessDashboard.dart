import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_paginator/enums.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:get/get.dart';
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
import 'package:jiffy/jiffy.dart';
import 'package:chewie_audio/chewie_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

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

class EyewitnessBodyState extends State<EyewitnessBody>
    with TickerProviderStateMixin {
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
      backgroundColor: Colors.white.withOpacity(1.0),
      body: Stack(
        children: [
          Paginator.listView(
            key: paginatorGlobalKey,
            pageLoadFuture: sendCountriesDataRequest,
            pageItemsGetter: listItemsGetter,
            listItemBuilder: listItemBuilder,
            loadingWidgetBuilder: loadingWidgetMaker,
            errorWidgetBuilder: errorWidgetMaker,
            emptyListWidgetBuilder: emptyListWidgetMaker,
            totalItemsGetter: totalPagesGetter,
            pageErrorChecker: pageErrorChecker,
            scrollPhysics: AlwaysScrollableScrollPhysics(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 7.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                backgroundColor: Colors.blueAccent,
                heroTag: Text('downloadReport'),
                onPressed: () {
                  paginatorGlobalKey.currentState.changeState(
                      pageLoadFuture: sendCountriesDataRequest,
                      resetState: true);
                },
                child: Icon(Icons.refresh),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<ReportsData> sendCountriesDataRequest(int page) async {
    try {
      String url =
          Uri.encodeFull('https://www.geotiscm.org/api/reports?page=$page');
      var response = await http.get(url, headers: {
        //HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $bearer",
        'Accept': 'application/json',
        'clientid': 'mobileclientpqqh6ebizhTecUpfb0qA',
      });
      debugPrint(response.body);
      return ReportsData.fromResponse(response);
    } catch (e) {
      if (e is IOException) {
        return ReportsData.withError('Please check your internet connection.');
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
  List<String> latitude = [];
  List<String> longitude = [];
  List<String> address = [];
  List<int> id = [];
  List<String> pictureList = [];
  List<String> status = [];
  List<String> state = [];
  List<String> crimeType = [];
  List<List<dynamic>> pictureListOfList = [];
  List<int> reportIdList = [];
  List<List<dynamic>> reportIdListOfList = [];
  List<dynamic> timeList = [];
  List<List<dynamic>> timeListOfList = [];
  List<dynamic> reportTypeId = [];
  List<List<dynamic>> reportTypeIdOfList = [];
  List<dynamic> list3 = [];

  List<double> locationContainerWidth = [];
  List<double> statusContainerWidth = [];
  List<double> addressWidth = [];
  List<double> addressHeight = [];
  List<bool> addressShowing = [];
  List<double> addressPosition = [];
  List<double> addressOpacity = [];
  List<int> _current = [];
  List<bool> statusText = [];
  List<bool> statusLoading = [];

  List<AudioPlayer> audioPlayer = [];
  List<int> audioDuration = [];
  List<double> expandAnimation = [];
  List<double> audioExpandDistance = [];
  List<bool> absorbFAB = [];
  List<bool> absorbPlayer = [];
  List<IconData> iconValue = [];
  List<String> audioPlayerCurrent = [];
  List<bool> isAudioLoadingVisible = [];

  @override
  void dispose() {
    super.dispose();
  }

  List<dynamic> listItemsGetter(ReportsData reportsData) {
    reportsData.reports.forEach((value) {
      //The Animation of Containers
      audioPlayer.add(AudioPlayer());
      audioDuration.add(0);
      expandAnimation.add(0.0);
      audioExpandDistance.add(0.0);
      absorbFAB.add(false);
      absorbPlayer.add(false);
      iconValue.add(Icons.play_arrow);
      audioPlayerCurrent.add('default');
      isAudioLoadingVisible.add(false);

      locationContainerWidth.add(0.0);
      statusContainerWidth.add(0.0);
      addressWidth.add(0.0);
      addressHeight.add(0.0);
      addressShowing.add(false);
      addressPosition.add(300.0);
      addressOpacity.add(0.0);
      _current.add(0);
      statusText.add(true);
      statusLoading.add(false);

      //The actual values
      firstName.add(value['user']['first_name']);
      lastName.add(value['user']['last_name']);
      email.add(value['user']['email']);
      avatar.add(value['user']['picture_url']);
      time.add(value['user']['created_at']);
      description.add(value['description']);
      var lat = value['location'];
      //latitude.add('7.2630339');
      //longitude.add('7.2630339');
      latitude.add(lat.substring(0, 8));
      longitude.add(lat.substring(10, 15));
      address.add(value['address']);
      id.add(value['id']);
      status.add(value['status']);
      state.add(value['state']['name']);
      crimeType.add(value['crimetype']['name']);
      //Picture Manipulation
      var report = value['reportcontent'];
      //print(report);
      for (var picItem in report) {
        pictureList.add(picItem['file_url']);
        reportIdList.add(picItem['report_id']);
        timeList.add(picItem['created_at']);
        reportTypeId.add(picItem['report_type_id']);
      }
      pictureListOfList.add(pictureList);
      reportIdListOfList.add(reportIdList);
      timeListOfList.add(timeList);
      reportTypeIdOfList.add(reportTypeId);

      pictureList = [];
      reportIdList = [];
      timeList = [];
      reportTypeId = [];
    });
    list3.addAll({
      firstName,
      lastName,
      email,
      avatar,
      time,
      description,
      latitude,
      longitude,
      address,
      status,
      state,
      crimeType,
      pictureListOfList,
      reportIdListOfList,
      timeListOfList,
      reportTypeIdOfList,
    });
    return list3;
  }

  Widget listItemBuilder(value, int index) {
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 10.0),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(5.0),
          // ),
          // elevation: 1.0,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Icon(Icons.person),
                        avatar[index] != null
                            ? CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(avatar[index]),
                                radius: 20.0,
                              )
                            : Center(
                                child: Container(
                                  width: 43.0,
                                  height: 43.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Color.fromRGBO(120, 78, 125, 1.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      firstName[index].substring(0, 1) +
                                          "" +
                                          lastName[index].substring(0, 1),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                ),
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
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 15.0),
                      color: Colors.white,
                      width: double.infinity,
                      child: Text(
                        description[index],
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.black),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Visibility(
                        // visible: pictureListOfList[index].isNotEmpty?true:false,
                        visible: true,
                        child: Stack(
                          children: [
                            pictureListOfList[index].isNotEmpty
                                ? audioCarousel(index)
                                : Center(
                                    child: Text(
                                      '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            pictureListOfList[index].isNotEmpty
                                ? pictureCarousel(index)
                                : Center(
                                    child: Text(
                                      '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            Align(
                              alignment: Alignment.center,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: addressOpacity[index],
                                curve: Curves.easeOut,
                                child: AnimatedContainer(
                                  transform: Matrix4.translationValues(
                                      0.0, addressPosition[index], 0.0),
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeOut,
                                  padding: EdgeInsets.all(10.0),
                                  height: addressHeight[index],
                                  width: addressWidth[index],
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: pictureListOfList[index].isNotEmpty
                                        ? Colors.white.withOpacity(0.7)
                                        : Colors.white.withOpacity(1.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.blueAccent,
                                        Color.fromRGBO(120, 78, 125, 1.0),
                                      ],
                                    ),
                                  ),
                                  child: ListView(
                                    children: [
                                      Text(
                                        'Address: ${address[index]}',
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Divider(
                                        color: Colors.white,
                                        thickness: 0.3,
                                      ),
                                      Text(
                                        'Latitude: ${latitude[index]}',
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Divider(
                                        color: Colors.white,
                                        thickness: 0.3,
                                      ),
                                      Text(
                                        'Longitude: ${longitude[index]}',
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Divider(
                                        color: Colors.white,
                                        thickness: 0.3,
                                      ),
                                      Text(
                                        'State: ${state[index]}',
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Divider(
                                        color: Colors.white,
                                        thickness: 0.3,
                                      ),
                                      Text(
                                        'Crime: ${crimeType[index]}',
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pictureListOfList[index].map((url) {
                      int myIndex = pictureListOfList[index].indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current[index] == myIndex
                              ? Colors.blueAccent.withOpacity(1.0)
                              : Color.fromRGBO(0, 0, 0, 0.5),
                        ),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, bottom: 9.0),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, right: 5.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () async {
                                int role =
                                    UserPreferences().retrieveUserTypeId();
                                if (role == 1 || role == 2) {
                                  setState(() {
                                    statusText[index] = false;
                                    statusLoading[index] = true;
                                  });
                                  print('This is an admin account');
                                  int statusCode = await GetUser()
                                      .approveReport(bearer, id[index]);
                                  // int statusCode = await GetUser()
                                  //     .approveReport(
                                  //         bearer, reportIdListOfList[index][0]);
                                  if (statusCode == 200) {
                                    setState(() {
                                      statusText[index] = true;
                                      statusLoading[index] = false;
                                      status[index] = 'Confirmed';
                                    });
                                    print('Successful in approving');
                                  } else {
                                    print('Unsuccessful in approving');
                                  }
                                } else {
                                  print('This is an eyewitness account');
                                }
                              },
                              child: AnimatedContainer(
                                onEnd: () {},
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  //border:Border.all(width: 1.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.blueAccent,
                                      Colors.blueAccent,
                                    ],
                                  ),
                                ),
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.fastLinearToSlowEaseIn,
                                height: 35.0,
                                width: statusContainerWidth[index],
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: statusText[index],
                                      child: Center(
                                        child: Text(
                                          status[index].capitalizeFirst,
                                          key: ValueKey('statusText $index'),
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: statusLoading[index],
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 15.0,
                                          height: 15.0,
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                            backgroundColor:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Opacity(
                                opacity: 0.5,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      statusContainerWidth[index] = 0.0;
                                      locationContainerWidth[index] = 200.0;
                                      addressHeight[index] = 200.0;
                                      addressWidth[index] = 250;
                                      addressPosition[index] = 10.0;
                                      addressOpacity[index] = 1.0;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35.0),
                                      border: Border.all(width: 1.0),
                                      color: Colors.white,
                                    ),
                                    child: Icon(Icons.location_on,
                                        color: Colors.black),
                                    width: 35.0,
                                    height: 35.0,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Opacity(
                                opacity: 0.5,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      statusContainerWidth[index] = 80.0;
                                      locationContainerWidth[index] = 0.0;
                                      addressHeight[index] = 0.0;
                                      addressWidth[index] = 0.0;
                                      addressPosition[index] = 300.0;
                                      addressOpacity[index] = 0.0;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35.0),
                                      border: Border.all(width: 1.0),
                                      color: Colors.white,
                                    ),
                                    child: Icon(
                                      Icons.security_outlined,
                                      color: Colors.black,
                                    ),
                                    width: 35.0,
                                    height: 35.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0, top: 60.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 15.0,
                                color: Colors.black.withOpacity(0.42),
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                  timeListOfList[index].isNotEmpty
                                      ? Jiffy(timeListOfList[index][0])
                                          .fromNow()
                                      : Jiffy(time[index]).fromNow(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black.withAlpha(130),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                ],
              ),
              Divider(),
            ],
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
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
          backgroundColor: Colors.blueAccent,
          strokeWidth: 3,
        ),
      ),
    );
  }

  Widget errorWidgetMaker(ReportsData reportsData, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 10.0,
          ),
          child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/checkNetwork.png',
                width: 200.0,
                height: 200.0,
              )),
        ),
        FlatButton(
          onPressed: retryListener,
          child: Opacity(
            opacity: 0.4,
            child: Text(
              'Check your network \nconnection and retry',
              style: GoogleFonts.fredokaOne(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w200),
            ),
          ),
        )
      ],
    );
  }

  Widget emptyListWidgetMaker(ReportsData reportsData) {
    return Center(
      child: Opacity(
        opacity: 0.4,
        child: Text(
          'You have not submitted\nany report',
          textAlign: TextAlign.center,
          style: GoogleFonts.fredokaOne(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w200),
        ),
      ),
    );
  }

  int totalPagesGetter(ReportsData reportsData) {
    return reportsData.total;
  }

  bool pageErrorChecker(ReportsData reportsData) {
    return reportsData.statusCode != 200;
  }

  Widget audioCarousel(int index) {
    return Visibility(
      visible: reportTypeIdOfList[index][0] == 3 ? true : false,
      child: CarouselSlider(
        //options: CarouselOptions(height: 400.0),
        options: CarouselOptions(
          disableCenter: false,
          height: 100.0,
          enableInfiniteScroll: false,
          viewportFraction: 1.0,
          scrollDirection: Axis.horizontal,
          onPageChanged: (myIndex, reason) {
            setState(() {
              _current[index] = myIndex;
              print(pictureListOfList[index]);
            });
          },
        ),

        items: pictureListOfList[index]
            .map((e) => Container(
                  child: getPlayerAnim(index, e),
                ))
            .toList(),
      ),
    );
  }

  Widget pictureCarousel(int index) {
    return Visibility(
      visible: reportTypeIdOfList[index][0] == 1 ? true : false,
      child: CarouselSlider(
        //options: CarouselOptions(height: 400.0),
        options: CarouselOptions(
          disableCenter: false,
          height: 400.0,
          enableInfiniteScroll: false,
          viewportFraction: 1.0,
          scrollDirection: Axis.horizontal,
          onPageChanged: (myIndex, reason) {
            setState(() {
              _current[index] = myIndex;
            });
          },
        ),
        items: pictureListOfList[index]
            .map((e) => Container(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CupertinoActivityIndicator()),
                    // progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(value: progress.progress),
                    imageUrl: e,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget getPlayerAnim(int index, String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 19.5, right: 19.5),
      child: Container(
        height: 75.0,
        width: 450.0,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10.0),
              padding: EdgeInsets.all(8.0),
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: Image.asset(
                          'assets/images/earphone.png',
                          fit: BoxFit.contain,
                          height: 40,
                          width: 40,
                        )),
                  ),
                  Visibility(
                    visible: isAudioLoadingVisible[index],
                    child: Center(
                      child: SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.purple),
                          backgroundColor: Colors.blueAccent,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            getPlayerInterface(index, url),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 2.0,
                    top: 4,
                  ),
                  child: Container(
                    height: 5.0,
                    width: 195.0,
                    color: Color.fromRGBO(120, 78, 125, 0.2),
                  ),
                ),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    AnimatedContainer(
                      duration:
                          Duration(seconds: expandAnimation[index].toInt()),
                      width: audioExpandDistance[index],
                      height: 5.0,
                      color: Color.fromRGBO(120, 78, 125, 1.0),
                    ),
                    AnimatedContainer(
                      duration:
                          Duration(seconds: expandAnimation[index].toInt()),
                      margin: EdgeInsets.only(left: audioExpandDistance[index]),
                      height: 13.0,
                      width: 13.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.0),
                        color: Color.fromRGBO(120, 78, 125, 1.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getPlayerInterface(int index, String url) {
    return Visibility(
      visible: true,
      child: GestureDetector(
        child: Icon(iconValue[index],
            size: 40.0, color: Color.fromRGBO(120, 78, 125, 1.0)),
        onTap: () async {
          if (audioPlayerCurrent[index] == 'default') {
            print('Called here 1');
            onPlayAudio(index, url);
            audioPlayer[index].onPlayerCompletion.listen((event) {
              setState(() {
                expandAnimation[index] = 0.0;
                audioExpandDistance[index] = 0;
                iconValue[index] = Icons.play_arrow;
                audioPlayerCurrent[index] = 'default';
                absorbFAB[index] = false;
              });
            });
          } else if (audioPlayerCurrent[index] == 'play') {
            onStopAudio(index);
            setState(() {
              expandAnimation[index] = 0.0;
              audioExpandDistance[index] = 0;
              iconValue[index] = Icons.play_arrow;
              audioPlayerCurrent[index] = 'default';
              absorbFAB[index] = false;
            });
          }
        },
      ),
    );
  }

void onPlayAudio(int index, url) async {
  isAudioLoadingVisible[index] = true;
  await audioPlayer[index].setUrl(url);
  await audioPlayer[index].play(url);
  audioPlayer[index].onDurationChanged.listen((Duration d) {
    isAudioLoadingVisible[index] = false;
    setState(() {
      audioPlayerCurrent[index] = 'play';
      iconValue[index] = Icons.stop;
      expandAnimation[index] = d.inSeconds.toDouble()+0.12; //d2.toDouble();
      audioExpandDistance[index] =
      190.0; //the width of the animated container
      absorbFAB[index] = true;
    });
  });
}

  void onStopAudio(int index) async {
    await audioPlayer[index].stop();
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
    reports = jsonData['data']['data'];
    total = jsonData['data']['total'];
    nItems = reports.length;
  }

  ReportsData.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}
