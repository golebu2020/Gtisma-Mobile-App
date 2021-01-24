import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/Screens/AdminLogin.dart';
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
      theme: ThemeData(fontFamily: 'Roboto'),
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
    var fontDesign=GoogleFonts.fredokaOne(fontSize: 17.0, color: Color.fromRGBO(120, 78, 125, 1.0));
    // var fontDesign = GoogleFonts.arvo(
    //     fontWeight: FontWeight.w900,
    //     fontSize: 15.0,
    //     color: Color.fromRGBO(120, 78, 125, 1.0));
    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 241, 241, 1.0),
      appBar: AppBar(
        title: Flash(
          child: Text("PREFERRED LANGUAGE", style: fontDesign,),
        ),
        elevation: 2.0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: 600,
        child: Container(
          child: ListView(
            children: [
              Lottie.asset('assets/images/animated_welcome.json',fit: BoxFit.cover, height:270.0, width: 60.0, ),
              SizedBox(
                height: 35.0,
              ),
              ShaderMaskIcon(Container(
                height: 57,
                margin: EdgeInsets.only(bottom: 5.0, right: 30.0, left: 30.0),
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
              )),
              ShaderMaskIcon(Container(
                height: 57,
                margin:
                    EdgeInsets.only(bottom: 5.0, right: 30.0, left: 30.0),
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
              )),
              ShaderMaskIcon(Container(
                height: 57,
                margin:
                    EdgeInsets.only(bottom: 5.0, right: 30.0, left: 30.0),
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
              )),
              Container(
                height: 57,
                margin:
                    EdgeInsets.only(bottom: 10.0, right: 30.0, left: 30.0),
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
    Navigator.push(
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
