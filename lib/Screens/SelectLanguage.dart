import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/Screens/CustomDashboard.dart';
import 'package:gtisma/Screens/IntroScreen.dart';
import 'package:gtisma/components/shader_mask_icon.dart';
import 'package:gtisma/helpers/NavigationPreferences.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EyewitnessDashboard.dart';
import 'EyewitnessLogin.dart';

// import 'WelcomePage.dart';

class SelectLanguage extends StatelessWidget {
  Widget signal;
  @override
  Widget build(BuildContext context) {
    var name = 'Nedu Olebu';
    var renamed = name.split(' ');
    print(renamed[1]);

    if (NavigationPreferences().retrieveSelectLanguage() == true) {
      debugPrint('the language state has been saved already');
      if (NavigationPreferences().retrieveIntroScreen() == true) {
        debugPrint('the intro screen has bee saved already');
        if (NavigationPreferences().retrieveLoginScreen() == true) {
          debugPrint('the login screen has already been called');
          //signal = EyewitnessDashboard();
          signal = CustomDashboard(pageType: false);
        } else {
          debugPrint('Just calling the Login Screen');
          signal = EyewitnessLoginStat();
        }
      } else {
        debugPrint('Just calling the intro screen');
        signal = IntroScreen();
      }
    } else {
      debugPrint('Just calling the Select Language');
      signal = Content();
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: Color.fromARGB(50, 20, 10, 10)),
    );
    return MaterialApp(
      title: 'Preferred Language',
      debugShowCheckedModeBanner: false,
      //color: Color.fromRGBO(230, 230, 230, 1.0),
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: signal,
    );
  }
}

class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  void initState() {
    // TODO: implement initState
    UserPreferences().storeSelectedLanguage(true);
    super.initState();
  }

  void changeState(String value) {
    setState(() {
      UserPreferences().setData(value);
      //save navigation information
      NavigationPreferences().storeSelectLanguage(true);
    });
  }

  @override
  Widget build(BuildContext context) {
   double height =  MediaQuery.of(context).size.height;
   double width =  MediaQuery.of(context).size.width;
   print(height);
   print(width);
   UserPreferences().saveGeneralHeight(height);
   UserPreferences().saveGeneralWidth(width);
    var fontDesign=GoogleFonts.fredokaOne(fontSize: 17.0, color: Color.fromRGBO(120, 78, 125, 1.0));
    // var fontDesign = GoogleFonts.arvo(
    //     fontWeight: FontWeight.w900,
    //     fontSize: 15.0,
    //     color: Color.fromRGBO(120, 78, 125, 1.0));
    return Scaffold(
     backgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      appBar: AppBar(
        title: Flash(
          child: Text("PREFERRED LANGUAGE", style: fontDesign,),
        ),
        elevation: 2.0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: height*0.89,
        child: Container(
          child: ListView(
            children: [
             Lottie.asset('assets/images/animated_welcome.json',fit: BoxFit.cover, height:height*0.41, width: 0.167*width, ),
              SizedBox(
                height: height*0.052,
              ),
              Container(
                height: height*0.085,
                margin: EdgeInsets.only(bottom: 0.0149*height/2, right: width*0.0833, left: width*0.0833),
                child: RaisedButton(
                  elevation: 0.0,
                  color: Color.fromRGBO(120, 78, 125, 1.0),
                  textColor: Colors.white,
                  splashColor: Color.fromRGBO(120, 78, 125, 1.0),
                  shape: StadiumBorder(),
                  child: Text("ENGLISH",
                      style: GoogleFonts.fredokaOne(fontSize: 16.0, color: Colors.white)),
                  onPressed: () {
                    changeState('E');
                    navigateAnotherPage(context, IntroScreen());
                    debugPrint('You selected English Language');
                  },
                ),
              ),
              Container(
                height: height*0.085,
                margin:
                    EdgeInsets.only(bottom: 0.0149*height/2, right: width*0.0833, left: width*0.0833),
                child: RaisedButton(
                  elevation: 0.0,
                  color: Color.fromRGBO(120, 78, 125, 1.0),
                  textColor: Colors.white,
                  splashColor: Color.fromRGBO(120, 78, 125, 1.0),
                  shape: StadiumBorder(),
                  child: Text("YORUBA",
                      style: GoogleFonts.fredokaOne(fontSize: 16.0, color: Colors.white)),
                  onPressed: () {
                    changeState('Y');
                    navigateAnotherPage(context, IntroScreen());
                    debugPrint('You selected Yoruba Language');
                  },
                ),
              ),
              Container(
                height: 0.085*height,
                margin:
                    EdgeInsets.only(bottom: 0.0149*height/2, right: width*0.0833, left: width*0.0833),
                child: RaisedButton(
                  elevation: 0.0,
                  color: Color.fromRGBO(120, 78, 125, 1.0),
                  textColor: Color.fromRGBO(120, 78, 125, 1.0),
                  splashColor: Color.fromRGBO(120, 78, 125, 1.0),
                  shape: StadiumBorder(),
                  child: Text("IGBO",
                      style: GoogleFonts.fredokaOne(fontSize: 16.0, color: Colors.white)),
                  onPressed: () {
                    changeState('I');
                    navigateAnotherPage(context, IntroScreen());
                    debugPrint('You selected Igbo langauge');
                  },
                ),
              ),
              Container(
                height: height*0.085,
                margin:
                    EdgeInsets.only(bottom: 0.0149*height, right: width*0.0833, left: width*0.0833),
                child: RaisedButton(
                  elevation: 0.0,
                  color: Color.fromRGBO(120, 78, 125, 1.0),
                  textColor: Color.fromRGBO(120, 78, 125, 1.0),
                  splashColor: Color.fromRGBO(120, 78, 125, 1.0),
                  shape: StadiumBorder(),
                  child: Text("HAUSA",
                      style: GoogleFonts.fredokaOne(fontSize: 16.0, color: Colors.white)),
                  onPressed: () {
                    changeState('H');
                    navigateAnotherPage(context, IntroScreen());
                    debugPrint('You selected Hausa language');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateAnotherPage(BuildContext cont, Widget screen) {
    Navigator.pushReplacement(
        cont,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeOutQuad;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              child: child,
              position: animation.drive(tween),
            );
          },
          pageBuilder: (context, animation, animationTime) {
            return screen;
          },
        ));
  }
}
