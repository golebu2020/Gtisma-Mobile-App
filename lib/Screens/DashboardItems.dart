import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardItems extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;
  final String time;
  final String description;
  final String latitude;
  final String longitude;
  final String address;
  final List<String> pictureList;
  final String status;
  DashboardItems(
      {Key key,
        this.firstName,
        this.lastName,
        this.email,
        this.avatar,
        this.time,
        this.description,
        this.latitude,
        this.longitude,
        this.address,
        this.pictureList,
        this.status})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: DashboardItemHome(firstName, lastName, email, avatar,time,description,latitude,longitude,address,pictureList,status),
    );
  }
}

class DashboardItemHome extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;
  final String time;
  final String description;
  final String latitude;
  final String longitude;
  final String address;
  final List<String> pictureList;
  final String status;
  DashboardItemHome(
      this.firstName,
      this.lastName,
      this.email,
      this.avatar,
      this.time,
      this.description,
      this.latitude,
      this.longitude,
      this.address,
      this.pictureList,
      this.status);

  @override
  _DashboardItemHomeState createState() => _DashboardItemHomeState();
}

class _DashboardItemHomeState extends State<DashboardItemHome>
    with SingleTickerProviderStateMixin {
  double locationContainerWidth = 0.0;
  double statusContainerWidth = 0.0;
  double addressWidth = 0.0;
  double addressHeight = 0.0;
  bool addressShowing = false;
  double addressPosition = 300.0;
  double addressOpacity = 0.0;
  int _current = 0;
  List<String> pictureList2 = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRnltfxyRHuEEUE4gIZp9fr77Q8goigP7mQ6Q&usqp=CAU",
    "https://imageproxy.themaven.net//https%3A%2F%2Fwww.history.com%2F.image%2FMTY1MTc3MjE0MzExMDgxNTQ1%2Ftopic-golden-gate-bridge-gettyimages-177770941.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-fff2lftqIE077pFAKU1Mhbcj8YFvBbMvpA&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRU2U6QAHfoDaofFbNo4OLtaqYWzihF5d4fhw&usqp=CAU"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Wrap(
        children: [
          Container(
            height: 500.0,
            color: Colors.white,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5.0,
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
                                  NetworkImage(widget.avatar),
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
                              child: Text(widget.firstName + ' ' + widget.lastName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(widget.email,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.0,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 80.0, top: 25.0),
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
                          child: Text(widget.description,
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
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
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
                                        int index = pictureList2.indexOf(url);
                                        return Container(
                                          width: 8.0,
                                          height: 8.0,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 2.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _current == index
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
                                      opacity: addressOpacity,
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: AnimatedContainer(
                                        transform: Matrix4.translationValues(
                                            0.0, addressPosition, 0.0),
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        padding: EdgeInsets.all(10.0),
                                        height: addressHeight,
                                        width: addressWidth,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: Colors.white,
                                        ),
                                        child: Text(widget.address,
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
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastLinearToSlowEaseIn,
                                color: Colors.white,
                                height: 50.0,
                                width: locationContainerWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Latitude: ${widget.latitude}\nLongitude: ${widget.longitude}',
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
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  color: Colors.white,
                                  height: 30.0,
                                  width: statusContainerWidth,
                                  child: RaisedButton(
                                    shape: StadiumBorder(),
                                    color: Color.fromRGBO(120, 78, 125, 1.0),
                                    onPressed: () {
                                      debugPrint('Activate');
                                    },
                                    child: Text(widget.status,
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
                                      statusContainerWidth = 0.0;
                                      locationContainerWidth = 200.0;
                                      addressHeight = 40.0;
                                      addressWidth = 250;
                                      addressPosition = 190.0;
                                      addressOpacity = 1.0;
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
                                      statusContainerWidth = 100.0;
                                      locationContainerWidth = 0.0;
                                      addressHeight = 0.0;
                                      addressWidth = 0.0;
                                      addressPosition = 300.0;
                                      addressOpacity = 0.0;
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
          ),
        ],
      ),
    );
  }
}
