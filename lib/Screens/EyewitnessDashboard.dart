import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_paginator/enums.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
//import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/dashboardComponents/ChewieListFeed.dart';
import 'package:gtisma/dashboardComponents/ChewieListItem.dart';
import 'package:gtisma/dashboardComponents/MakeAPictureDashboard.dart';
import 'package:gtisma/dashboardComponents/MyReportsDashboard.dart';
import 'package:gtisma/dashboardComponents/SelectCrimeTypes.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:gtisma/helpers/GlobalVariables.dart';
import 'package:gtisma/models/UserReport.dart';
import 'DashboardItems.dart';
import 'EyewitnessLogin.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
//import 'package:line_icons/line_icons.dart';
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
import 'package:chewie/chewie.dart';
import 'package:gtisma/helpers/UserPreferences.dart';

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
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();

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
            padding: EdgeInsets.only(bottom: 0.01041667*height),
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
  List<VideoPlayerController> videoPlayerController = [];
  List<List<VideoPlayerController>> videoPlayerControllerOfList = [];
  List<ChewieController> chewieController = [];
  List<List<ChewieController>> chewieControllerOfList = [];
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
      statusContainerWidth.add(80.0);
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
        // //videoPlayerController.add(VideoPlayerController.network(picItem['file_url']));
        // var vidCont = VideoPlayerController.network(picItem['file_url']);
        chewieController.add(ChewieController(
          videoPlayerController: VideoPlayerController.network(picItem['file_url']),
          aspectRatio: VideoPlayerController.network(picItem['file_url']).value.aspectRatio,
          autoInitialize: true,
          looping: false,
          showControls: true,
          errorBuilder: (context, errorMessage) {
            return Center(
              child:
              Text('NO VIDEO\nCAPTURED', style: TextStyle(color: Colors.white)),
            );
          },
        ));
        reportIdList.add(picItem['report_id']);
        timeList.add(picItem['created_at']);
        reportTypeId.add(picItem['report_type_id']);
      }
      chewieControllerOfList.add(chewieController);
      pictureListOfList.add(pictureList);
      reportIdListOfList.add(reportIdList);
      timeListOfList.add(timeList);
      reportTypeIdOfList.add(reportTypeId);
      //videoPlayerControllerOfList.add(videoPlayerController);

      chewieController= [];
      pictureList = [];
      reportIdList = [];
      timeList = [];
      reportTypeId = [];
      //videoPlayerController = [];
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
      chewieControllerOfList
    });
    return list3;
  }

  Widget listItemBuilder(value, int index) {
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0.01488095*height),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(5.0),
          // ),
          // elevation: 1.0,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left:  0.027778*width, right: 0.027778*width, top: 0.01488095*height),
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
                                  width: 0.119444*width,
                                  height: 0.119444*width,
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
                          padding: EdgeInsets.only(left: 0.05556*width),
                          child: Text(firstName[index] + ' ' + lastName[index],
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15.0,
                                color: Colors.black,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 0.05556*width),
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
                    padding: EdgeInsets.only(left: 0.027778*width, right: 0.027778*width),
                    child: Container(
                      margin: EdgeInsets.only(top: 0.02976*height, bottom: 0.02232*height),
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
                                ? pictureCarousel(index)
                                : Center(
                                    child: Text(
                                      '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
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
                                ? videoCarousel(index)
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
                        width: 0.02222*width,
                        height: 0.011905*height,
                        margin: EdgeInsets.symmetric(
                            vertical: 0.014881*height, horizontal: 0.005556*width),
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
                    padding: EdgeInsets.only(left: 0.027778*width, right:0.027778*width, bottom: 0.013393*height),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0.014881*height, right: 0.0138889*width),
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
                                height: 0.052083*height,
                                width: statusContainerWidth[index],
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: statusText[index],
                                      child: Center(
                                        child: Text(
                                          status[index].toLowerCase(),
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
                                          width: 0.0416667*width,
                                          height: 0.022321*height,
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
                          padding: EdgeInsets.only(top: 0.01488095*height),
                          child: Row(
                            children: [
                              Opacity(
                                opacity: 0.5,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      statusContainerWidth[index] = 0.0;
                                      locationContainerWidth[index] = 0.55556*width;//200.0;
                                      addressHeight[index] = 0.29762*height;//200.0;
                                      addressWidth[index] = 0.69444*width; //250;
                                      addressPosition[index] = 10.0;
                                      addressOpacity[index] = 1.0;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35.0),
                                      border: Border.all(width: 0.0027778*width),
                                      color: Colors.white,
                                    ),
                                    // child: Image.asset(
                                    //   'assets/images/placeholder.png',
                                    // ),
                                    child: Icon(Icons.location_on,
                                        color: Colors.black),
                                    width:  0.0520833*height,
                                    height: 0.0520833*height,
                                  ),
                                ),
                              ),
                              SizedBox(width: 0.0416667*width),
                              Opacity(
                                opacity: 0.5,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      statusContainerWidth[index] = 0.22222*width;
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
                                    width:  0.0520833*height,
                                    height: 0.0520833*height,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 0.00556*width, top: 0.089286*height),
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
                  SizedBox(height: 0.0074405*height),
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
      height: 0.238095*height,//160.0,
      child: SizedBox(
        width: 0.138889*width,//50.0,
        height: 0.138889*width,//50.0,
        child: CircularProgressIndicator(
          // valueColor: AlwaysStoppedAnimation<Color> (Colors.black45.withOpacity(0.3)),
          // backgroundColor: Colors.blueGrey.shade200,
          //Color.fromRGBO(120, 78, 125, 1.0),
          valueColor: AlwaysStoppedAnimation<Color> (Color.fromRGBO(120, 78, 125, 1.0)),
          backgroundColor: Color.fromRGBO(120, 78, 125, 0.5),
          strokeWidth: 10,
        ),
      ),
    );
  }

  Widget errorWidgetMaker(ReportsData reportsData, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            left: 0.04444*width,
            right: 0.04444*width,
            bottom: 0.014881*height,
          ),
          child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/checkNetwork.png',
                width: 0.55556*width,
                height: 0.29762*height,
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

  Widget videoCarousel(int index) {
    return Visibility(
      visible: reportTypeIdOfList[index][0] == 2 ? true : false,
      child: CarouselSlider(
        //options: CarouselOptions(height: 400.0),
        options: CarouselOptions(
          disableCenter: false,
          height: 0.59524*height,//400.0,
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
          child: getVideoPlayer(index, e),
          //child: getPlayerAnim(index, e),
        ))
            .toList(),
      ),
    );
  }

  Widget getVideoPlayer(int index, String url){
    //child: ChewieListItem(videoPlayerController: VideoPlayerController.file(widget.file), looping: true, urlKey: UniqueKey()),
    //return ChewieListFeed(videoPlayerController: videoPlayerControllerOfList[index][0], looping: false, myKey: UniqueKey());
    return Container(
      //color: Colors.black,
      child: Chewie(
        controller: chewieControllerOfList[index][0],
      ),
    );
  }
  Widget audioCarousel(int index) {
    return Visibility(
      visible: reportTypeIdOfList[index][0] == 3 ? true : false,
      child: CarouselSlider(
        //options: CarouselOptions(height: 400.0),
        options: CarouselOptions(
          disableCenter: false,
          height: 0.1041667*height,
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
          height: 0.595238*height,
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
                        width: 0.05556*width,
                        height: 0.029762*height,
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
      padding: EdgeInsets.only(top: 0.014881*height, left: 0.054167*width, right: 0.054167*width),
      child: Container(
        height: 0.11161*height,
        width: 1.25*width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color.fromRGBO(120, 78, 125, 0.1), Color.fromRGBO(41,78,149,0.1)],
          ),
        ),
        // decoration: BoxDecoration(
        //   //color: Colors.deepPurple.withOpacity(0.1),
        //   color: Colors.blue.withOpacity(0.1),
        //   borderRadius: BorderRadius.circular(50.0),
        // ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 0.027778*width),
              padding: EdgeInsets.all(8.0),
              width: 0.138889*width,
              height: 0.138889*width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                        height: 0.037202*height,
                        width: 0.037202*height,
                        child: Image.asset(
                          'assets/images/earphone.png',
                          fit: BoxFit.contain,
                        )),
                  ),
                  Visibility(
                    visible: isAudioLoadingVisible[index],
                    child: Center(
                      child: SizedBox(
                        height: 0.059524*height,
                        width: 0.059524*height,
                        child: Opacity(
                          opacity: 0.5,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color> (Color.fromRGBO(120, 78, 125, 1.0)),
                            backgroundColor: Color.fromRGBO(120, 78, 125, 0.5),
                            strokeWidth: 3,
                          ),
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
                  padding: EdgeInsets.only(
                    left: 0.005556*width,
                    top: 0.009673*height,
                  ),
                  child: Container(
                    height: 0.0029762*height,
                    width: 0.541667*width,
                   color: Colors.white,
                    //color: Colors.black45,
                  ),
                ),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    AnimatedContainer(
                      duration:
                          Duration(seconds: expandAnimation[index].toInt()),
                      width: audioExpandDistance[index],
                      height: 0.0029762*height,
                      color: Colors.blueAccent,
                    ),
                    AnimatedContainer(
                      duration:
                          Duration(seconds: expandAnimation[index].toInt()),
                      margin: EdgeInsets.only(left: audioExpandDistance[index]),
                      height: 0.022321*height,
                      width: 0.022321*height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.0),
                        color: Colors.blueAccent,
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
            size: 45.0, color: Color.fromRGBO(120, 78, 125, 1.0)),
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
    setState(() {
      isAudioLoadingVisible[index] = true;
    });
    await audioPlayer[index].setUrl(url);
    await audioPlayer[index].play(url);
    audioPlayer[index].onDurationChanged.listen((Duration d) {
      setState(() {
        isAudioLoadingVisible[index] = false;
        audioPlayerCurrent[index] = 'play';
        iconValue[index] = Icons.stop;
        expandAnimation[index] =
            d.inSeconds.toDouble() + 0.15; //d2.toDouble();
        audioExpandDistance[index] = 0.527778*width; //the width of the animated container
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
