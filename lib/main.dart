import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gtisma/AnimatedComponents/VideoPage/Videos.dart';
import 'package:gtisma/Screens/EyewitnessLogin.dart';
import 'package:gtisma/Screens/PickLanguage.dart';
import 'package:gtisma/Screens/SelectLanguage.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';


import 'AnimatedComponents/AudioPage/Audios.dart';
import 'AnimatedComponents/AudioRecoding.dart';
import 'Screens/EyewitnessDashboard.dart';
import 'Screens/EyewitnessRegister.dart';
import 'dashboardComponents/AnimationPractice.dart';
import 'dashboardComponents/MakeAVideoDashboard.dart';
import 'helpers/NavigationPreferences.dart';
import 'helpers/push_notifications.dart';
import 'dashboardComponents/MakeAPictureDashboard.dart';

void main(){
 runApp(MyApp());
 //runApp(AudioRecording());
// runApp(PickLang());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(fontFamily:'Roboto-Light' ),
        title: 'Clean Code',
        debugShowCheckedModeBanner: false,
        home: HomeApp()
    );
  }

}

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();

}

class _HomeAppState extends State<HomeApp>{

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    // TODO: implement initState
    UserPreferences().init();
    NavigationPreferences().init(); //for Navigation between screens
    PushNotificationManager().init(); //for Push Notifications
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return BackgroundDecoration();
  }

}

class BackgroundDecoration extends StatelessWidget {
  Widget wi = AnimatedSplashScreen(
    splashIconSize: 90,
    duration: 3000,
    centered: true,
    splash: 'assets/images/splash_icon_3.jpg',
    nextScreen: SelectLanguage(),
    splashTransition: SplashTransition.fadeTransition,
    backgroundColor: Color.fromRGBO(120, 78, 125, 0.0),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color.fromRGBO(120, 78, 125, 1.0), Color.fromRGBO(41,78,149,1.0)],
        ),
      ),
      child: wi,
    );
  }
}
