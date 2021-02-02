import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gtisma/CustomViews/CustomProgressBar.dart';
import 'package:gtisma/CustomViews/DialogAwesome.dart';
import 'package:gtisma/CustomViews/SocialMediaSignup.dart';
import 'package:gtisma/Screens/ForgotPassword.dart';
import 'package:gtisma/components/CustomButtons.dart';
import 'package:gtisma/helpers/NavigationPreferences.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CustomDashboard.dart';
import 'DashboardItems.dart';
import 'EyewitnessDashboard.dart';
import 'EyewitnessRegister.dart';
import 'package:gtisma/Screens/EyewitnessDashboard.dart';

import 'package:gtisma/helpers/GlobalVariables.dart';

var emailController = TextEditingController();
var passwordController = TextEditingController();
SelectLanguage lang = SelectLanguage();


class EyewitnessLoginStat extends StatefulWidget {

  const EyewitnessLoginStat({Key key}) : super(key: key);

  @override
  EyewitnessLoginStatState createState() => EyewitnessLoginStatState();
}

class EyewitnessLoginStatState extends State<EyewitnessLoginStat> {
  dynamic nativeLanguage = "";
  PageController pageController = PageController(
    initialPage: 0,
  );
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool _isLoggedIn = false;
  var url = 'https://www.geotiscm.org/api/auth/login';
  var data;
  var len;
  bool _isVisible = false;
  bool _isAbsorbing = false;
  void printSuccess(){
    print('Success');
  }
  void initState() {
    nativeLanguage = UserPreferences().data;
    super.initState();

    //this.loginData();

  }

  void setAbsorb() {
    setState(() {
      _isAbsorbing = !_isAbsorbing;
    });
  }

  void setProgress() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }
  BuildContext ScaffoldContext;
  Future<dynamic> loginData(String email, String pass) async {
    if (email.isNotEmpty && pass.isNotEmpty) {
      var response = await http.post(Uri.encodeFull(url), headers: {
        'clientId': 'mobileclientpqqh6ebizhTecUpfb0qA'
      }, body: {
        'email': email,
        'password': pass,
        'firebase_token': UserPreferences().retrieveFirebaseID() != null?UserPreferences().retrieveFirebaseID():"",
        'device_id': UserPreferences().retrieveDeviceID() != null?UserPreferences().retrieveDeviceID():"",
      });
      var cooldata = json.decode(response.body);

      print(cooldata);
      print(response.statusCode);

      if (response.statusCode == 200) {
        UserPreferences().storeUserData(cooldata['data']);
        List<String> personalInfo = await GetUser().getLoginUser(cooldata['data']);
        UserPreferences().storeSocialLoginName(personalInfo[0] + ' ' + personalInfo[1]);
        UserPreferences().storeSocialLoginEmail(personalInfo[2]);
        UserPreferences().storeSocialLoginPicURL(personalInfo[3]);
        UserPreferences().storeUserTypeId(int.parse(personalInfo[4]));
        // showDialogBox("Your login was successful!");
        setProgress();
        setAbsorb();
        NavigationPreferences().storeLoginScreen(true);
        //Navigator.push(context, CupertinoPageRoute(builder:(context)=> AdminConfirmPage()));
        NavigationPreferences().storeLoginScreen(true);
        Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(seconds: 1),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.easeOutQuad;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  child: child,
                  position: animation.drive(tween),
                );
              },
              pageBuilder: (context, animation, animationTime) {
                return CustomDashboard(pageType: false);
              },
            ));
        //Navigator.of(context).push(PageTransition(child: AdminConfirmPage(), type: PageTransitionType.slideRight));
        //Save information in shared preference
      } else {
        showDialogBox(cooldata['message']);
        //DialogAwesome().showMyDialog(context, 'Error', cooldata['message']);
        setProgress();
        setAbsorb();
      }
    } else {
      showDialogBox("None of the fields must be empty!");
      //DialogAwesome().showMyDialog(ScaffoldContext, 'Error', 'None of the fields must be empty!');
    // showSnackBar("None of the fields must be empty!");
      setProgress();
      setAbsorb();
    }
    return "Success";
  }

  var social = SocialMediaSignup();
  Widget firstPage() {
    return Container(
      width: 320,
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Container(
            height: 55,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: TextFormField(

              style: TextStyle(fontFamily: 'Roboto-Light'),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(242, 242, 242, 1.0),
                contentPadding: EdgeInsets.all(10.0),

                hintText: lang.languagTester(
                    nativeLanguage)[17],
                labelText: lang.languagTester(
                    nativeLanguage)[17],
               // enabledBorder: ,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                  enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                prefixIcon: const Icon(Icons.email,
                    color:Color.fromRGBO(120, 78, 125, 1.0)),
              ),
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(242, 242, 242, 1.0),
                contentPadding: EdgeInsets.all(10.0),
                hintText: lang.languagTester(
                    nativeLanguage)[20],
                labelText: lang.languagTester(
                    nativeLanguage)[20],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                prefixIcon: const Icon(Icons.lock,
                    color: Color.fromRGBO(120, 78, 125, 1.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }


  ElevatedButton buttonContinue(BuildContext cont, bool value, String disp) {
    return ElevatedButton(

      style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(120, 78, 125, 1.0),
          onPrimary: Colors.white,
          elevation: 0.0),
      onPressed: () {
        setState(() {
          loginData(emailController.text.toString(),
              passwordController.text.toString());
        });
        // Navigator.push(
        //     cont,
        //     MaterialPageRoute(builder: (context) => PostsPage()));
      },
      child: Text(
        disp,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget progressBar(BuildContext context, bool value, String disp) {
    return Container(
      //margin: EdgeInsets.only(top: 20),
      width: 300,
      height: 60,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 280,
            child: AbsorbPointer(
              absorbing: _isAbsorbing,
              child: RaisedButton(
                shape: StadiumBorder(),
                color: Color.fromRGBO(120, 78, 125, 1.0),
                onPressed: () {
                  debugPrint('Do something');
                  setState(() {
                    _isVisible = true;
                    _isAbsorbing = true;
                    loginData(emailController.text.toString(),
                        passwordController.text.toString());
                  });
                },
                child: Text(
                  disp.toUpperCase(),
                  style: GoogleFonts.fredokaOne(
                      color: Colors.white, fontSize: 15.0),
                ),
              ),
            ),
          ),
          Visibility(
              visible: _isVisible,
              child: Container(
                  margin: EdgeInsets.only(right: 10.0, left: 10.0),
                  height: 4,
                  child: CustomProgressBar().customLinearProgress)),
        ],
      ),
    );
  }

  SocialMediaSignup design = SocialMediaSignup();

  @override
  Widget build(BuildContext context) {
    var fontDesign =  GoogleFonts.fredokaOne(
        color: Color.fromRGBO(120, 78, 125, 1.0), fontSize: 18.0);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eyewitness Login',
      home: Scaffold(
        appBar: AppBar(
          title: Text(lang.languagTester(
              nativeLanguage)[25].toUpperCase(),
            style:fontDesign),
          centerTitle: true,
          elevation: 2.0,
          backgroundColor: Colors.white,
        ),
        body: Builder(builder: (BuildContext context) {
          ScaffoldContext = context;
          return PageViewSocialMedia();
        }),
      ),
    );
  }

  // showDialogBox(String errorMessage) async{
  //   CustomDialogBox dBox = CustomDialogBox();
  //   dBox.openCustomDialog(context, "Login Information", errorMessage);
  // }
  showSnackBar(String errorMessage) async {
    final snackBar = SnackBar(
      content: Container(
          height: 20,
          child: Center(
            child: Text(errorMessage,
                style: GoogleFonts.robotoSlab(fontSize: 14.0)),
          )),
      backgroundColor: Colors.red,
    );
    Scaffold.of(ScaffoldContext).showSnackBar(snackBar);
  }

  showDialogBox(String errorMessage) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Information"),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  doSomething() {
    setState(() {
      debugPrint('Do something');
    });
  }

  Widget LoginPage(){
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(10.0),
        //margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 20.0,
            ),
            SvgPicture.asset(
              'assets/images/login.svg',
              height: 200.0,
              width: 200.0,
            ),
            Container(
              width: 330,
              height: 330,
              child: Column(
                children: [
                  firstPage(),
                  Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: progressBar(context, false, lang.languagTester(
                        nativeLanguage)[23],),
                    //buttonContinue(context, false, 'Submit'),
                  ),
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextButton(
                          child: Text(
                              lang.languagTester(
                                  nativeLanguage)[31],
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                decorationColor: Colors.purple),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: Duration(seconds: 1),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    var begin = Offset(1.0, 0.0);
                                    var end = Offset.zero;
                                    var curve = Curves.easeOutBack;
                                    var tween = Tween(
                                        begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    var offsetAnimation =
                                    animation.drive(tween);
                                    return SlideTransition(
                                      child: child,
                                      position: animation.drive(tween),
                                    );
                                  },
                                  pageBuilder:
                                      (context, animation, animationTime) {
                                    return Experiment();//Login Page
                                  },
                                ));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 21.0),
                        child: TextButton(
                          child: Text(
                            lang.languagTester(
                                nativeLanguage)[32],
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                decorationColor: Colors.purple),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        ForgotPassword()));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget PageViewSocialMedia(){
    return PageView(
     // physics: NeverScrollableScrollPhysics(),
      children: [
        LoginPage(),
      ],
      controller:pageController,
    );
  }

}
// setState(() {
// _start = false;
// _recordVideo(context);
// });
// new Timer.periodic(
// Duration(milliseconds: 100),
// (Timer timer) => setState(
// () {
// _start = true;
// _recordVideo(context);
// },
// ),
// );