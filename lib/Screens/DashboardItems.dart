import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.robotoSlabTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Wrap(
          children: [
            Container(
              color: Colors.white,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                AssetImage('assets/images/signup.png'),
                            radius: 25.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text('Chinedu Olebu',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15.0, color: Colors.black.withAlpha(170),)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text('cgolebu@gmail.com',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13.0, color: Colors.black.withAlpha(170),)),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 94.0, top: 25.0),
                            child: Text('10.50pm',
                                style: TextStyle(
                                  fontSize: 12.0,color: Colors.black.withAlpha(170),
                                )),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20.0, bottom: 15.0),
                            color: Colors.white,
                            width: double.infinity,
                            child: Text(
                              "There are three enemies of personal peace regret over yesterday's mistakes anxiety over tomorrow's problems ingratitude for today's blessings many of life failures are those who did now know how close they to success when they gave up. What does love look like it "
                              "has the hands to help others it has the feet to resuc",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black.withAlpha(170)),
                            ),
                          ),
                          Stack(
                            children: [
                              Visibility(
                                visible: true,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                          "assets/images/place_holder.png",
                                          height: 220.0,
                                          fit: BoxFit.cover,
                                          width: double.infinity),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                          "https://res.cloudinary.com/https-www-geotiscm-org/image/upload/v1611439131/gtisma/reports/appjjbr26lfz1lplahwr.jpg",
                                          height: 220.0,
                                          fit: BoxFit.cover,
                                          width: double.infinity),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Divider(
                            height: 15.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                child: Text(
                                  'Pending',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Get.snackbar(
                                    "Hey i'm a Get SnackBar!", // title
                                    "It's unbelievable! I'm using SnackBar without context, without boilerplate, without Scaffold, it is something truly amazing!", // message
                                    icon: Icon(Icons.alarm),
                                    shouldIconPulse: true,
                                    barBlur: 20,
                                    isDismissible: true,
                                    duration: Duration(seconds: 3),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 240.0,
                                        child: Text(
                                          'This is very longggggg. This is very longggggg. This is very longggggg',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black.withAlpha(170),
                                              fontWeight: FontWeight.w900,),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        )),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text('Longitude: 7.2630339, ',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black
                                                        .withAlpha(170))),
                                            Text('Latitude: 5.1743272',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black
                                                        .withAlpha(170))),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 91.0),
                                          child: Icon(
                                            Icons.location_on,
                                            color: Color.fromRGBO(
                                                120, 78, 125, 1.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
