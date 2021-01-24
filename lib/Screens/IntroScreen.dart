import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gtisma/helpers/GlobalVariables.dart';
import 'package:gtisma/helpers/NavigationPreferences.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'EyewitnessLogin.dart';



// APP INTRODUCTORY SCREEN
SelectLanguage lang = SelectLanguage();
class IntroScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Introduction screen',
     debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple, fontFamily: 'Roboto'),
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  dynamic nativeLanguage="";
  //Fetch Language from shared preferences
  @override
  void initState() {
    // TODO: implement initState
    nativeLanguage = UserPreferences().data;
    NavigationPreferences().storeIntroScreen(true);
    //UserPreferences().storeIntroScreen(true);
    super.initState();
  }



  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeOutQuad;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              child: child,
              position: animation.drive(tween),
            );
          },
          pageBuilder: (context, animation, animationTime) {
            return EyewitnessLoginStat();
          },
        ));
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (_) => WelcomePage()),
    // );
  }
  //
  @override
  Widget build(BuildContext context) {

   // debugPrint(prefs.get("LangS"));

    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.only(top: 20),
    );

    return IntroductionScreen(
      key: introKey,
      // child: Text("Hausa", style: GoogleFonts.robotoSlab(
      //     fontWeight: FontWeight.w600, fontSize: 15.0)
      // ),
      pages: [
        PageViewModel(
          title: lang.languagTester(nativeLanguage)[0].toUpperCase(),
          body: lang.languagTester(nativeLanguage)[1],
          image: Image.asset('assets/images/intro_screen2_1.png',),
          decoration: const PageDecoration(
            pageColor: Color.fromRGBO(120, 78, 125, 1.0),
            titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
            bodyTextStyle: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w100),
            imagePadding: EdgeInsets.fromLTRB(40, 40, 40, 0),
          ),
        ),
        PageViewModel(
          title: lang.languagTester(nativeLanguage)[2].toUpperCase(),
          body: lang.languagTester(nativeLanguage)[3],
          image: Image.asset('assets/images/intro_screen2_2.png'),
          decoration: const PageDecoration(
            pageColor: Color.fromRGBO(81, 99, 149, 1.0),
            titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
            bodyTextStyle: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w100),
            imagePadding: EdgeInsets.fromLTRB(40, 40, 40, 0),
          ),
        ),
        PageViewModel(
          title: lang.languagTester(nativeLanguage)[4].toUpperCase(),
          body:lang.languagTester(nativeLanguage)[5],
          image: Image.asset('assets/images/intro_screen2_3.png'),
          decoration: const PageDecoration(
            pageColor: Color.fromRGBO(64, 141, 253, 1.0),
            titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
            bodyTextStyle: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w100),
            imagePadding: EdgeInsets.fromLTRB(60, 60, 60, 0),
          ),
        ),
        PageViewModel(
          title: lang.languagTester(nativeLanguage)[6].toUpperCase(),
          body: lang.languagTester(nativeLanguage)[7],
          image: Image.asset('assets/images/intro_screen2_4.png'),
          decoration: const PageDecoration(
            pageColor: Color.fromRGBO(174, 98, 133, 1.0),
            titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
            bodyTextStyle: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w100),
            imagePadding: EdgeInsets.fromLTRB(60, 60, 60, 0),
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: Text(lang.languagTester(nativeLanguage)[8],style: TextStyle(color: Colors.white),),
      next: const Icon(Icons.arrow_forward, color: Colors.white),
      done: Text(lang.languagTester(nativeLanguage)[9], style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}



