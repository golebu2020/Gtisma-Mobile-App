import 'dart:ui';

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
  double height = UserPreferences().getGeneralHeight();
  double width = UserPreferences().getGeneralWidth();
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
  bool _loginProgressVisible = false;
  bool _loginButtonVisible = true;

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
        _loginProgressVisible = _loginProgressVisible;
        _loginButtonVisible = !_loginProgressVisible;
        NavigationPreferences().storeLoginScreen(true);
        //Navigator.push(context, CupertinoPageRoute(builder:(context)=> AdminConfirmPage()));
        NavigationPreferences().storeLoginScreen(true);
        emailController.clear();
        passwordController.clear();
        Navigator.pushReplacement(
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
        _loginProgressVisible = false;
        _loginButtonVisible = !_loginProgressVisible;
      }
    } else {
      showDialogBox("None of the fields must be empty!");
      //DialogAwesome().showMyDialog(ScaffoldContext, 'Error', 'None of the fields must be empty!');
    // showSnackBar("None of the fields must be empty!");
      setProgress();
      setAbsorb();
      _loginProgressVisible = false;
      _loginButtonVisible = !_loginProgressVisible;
    }
    return "Success";
  }
//EdgeInsets.only(top: 0.0149*height),
  var social = SocialMediaSignup();
  Widget firstPage() {
    return Container(
      margin: EdgeInsets.only(top: 0.0149*height*2.5),
      child: Column(
        children: [
          SizedBox(
            height: 0.0893*height,
            width: 0.8333*width,
            child: TextFormField(
              minLines: 1,
                maxLines: 1,
                textAlign: TextAlign.start,
                style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 15.0),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(242, 242, 242, 0.5),
                  contentPadding: EdgeInsets.only(left: 0.0278*width, right: 0.0278*width, top: 0.0595*height,),
                  hintText: lang.languagTester(
                      nativeLanguage)[17],
                  // labelText: lang.languagTester(
                  //     nativeLanguage)[17],
                 // enabledBorder: ,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    borderSide: BorderSide(color: Colors.grey[300]),
                  ),
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                      borderSide: BorderSide(color: Colors.grey[300]),
                  ),
                  prefixIcon: const Icon(Icons.email,
                      color: Color.fromRGBO(120, 78, 125, 1.0)),
                ),
              ),
          ),
          SizedBox(height: 0.02232*height*0.2),
          SizedBox(
            height: 0.0893*height,
            width: 0.8333*width,
            //padding: EdgeInsets.fromLTRB(0.056*width, 0.0223*height, 0.056*width, 0),
            child: TextFormField(
              controller: passwordController,
              style: TextStyle(fontFamily: 'Roboto-Light', fontSize: 15.0),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(242, 242, 242, 0.5),
                contentPadding: EdgeInsets.only(left: 0.0278*width, right: 0.0278*width, top: 0.0595*height,),
                hintText: lang.languagTester(
                    nativeLanguage)[20],
                // labelText: lang.languagTester(
                //     nativeLanguage)[20],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
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
      child: Column(
        children: [
          Container(
            height: 0.0892*height,
            width: 0.778*width,
            child: AbsorbPointer(
              absorbing: _isAbsorbing,
              child: RaisedButton(
                //shape: StadiumBorder(),
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
                  margin: EdgeInsets.only(right: 0.0278*width, left: 0.0278*width),
                  height: 0.00744*height,
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
          height: 0.0298*height,
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
bool heightValue = false;
  Widget LoginPage(){
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              //margin: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 0.0298*height,
                  ),
                  Hero(child: Container(child: Image.asset("assets/images/latest_logo.png",width: 150, height: 150)), tag: "resetTag",),
                  //SvgPicture.asset("assets/images/login.svg", width: 150, height: 150,),
                  //Image.asset("assets/images/login_icon_two.png", width: 200.0, height: 200.0, scale:1.0, color: Colors..withOpacity(0.4),),
                  //Align(alignment: Alignment.topCenter,child: Image.asset("assets/images/splash_icon_3.jpg", width: 100,height: 100, )),
                  SizedBox(
                    height: 0.0298*height*1,
                  ),
                  Container(
                    height: 0.4911*height*1.5,
                    child: Column(
                      children: [
                        firstPage(),
                        NewCustomButton(lang.languagTester(nativeLanguage)[23],),
                        signupButton(lang.languagTester(nativeLanguage)[31]),
                        SizedBox(
                          height: 0.0298*height*3,
                        ),
                        TextButton(
                          child: Text(
                            lang.languagTester(
                                nativeLanguage)[32],
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                decorationColor: Colors.purple),
                          ),
                          onPressed: () {
                            // setState(() {
                            //   heightValue = true;
                            // });
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        ForgotPassword()));

                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // AnimatedContainer(
            //   height: heightValue == false?0:height,
            //   curve: Curves.easeInOut,
            //   width: double.infinity,
            //   duration: Duration(milliseconds: 500),
            //   child: ForgotPassword(),
            // ),
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

  Widget NewCustomButton(String disp){
    var fontDesign =  GoogleFonts.fredokaOne(
        color: Colors.white, fontSize: 15.0);
    return AbsorbPointer(
      absorbing: _isAbsorbing,
      child: Container(
        height: 0.0893*height,
        width: 0.8333 * width,
        margin: EdgeInsets.only(top: 0.0149*height),
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {
            setState(() {
              _isAbsorbing = true;
              _loginButtonVisible = !_loginButtonVisible;
              _loginProgressVisible = !_loginProgressVisible;
            });
            debugPrint('Thank you');
            loginData(emailController.text.toString(),
                passwordController.text.toString());

          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Visibility(visible: _loginButtonVisible,child: Text(
              disp.toUpperCase(),
          style: GoogleFonts.fredokaOne(
              color: Colors.white, fontSize: 15.0),
        ),),
              Visibility(
                visible: _loginProgressVisible,
                child: SizedBox(
                  height: 50/1.5,
                  width: 50/1.5,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color> (Colors.black45.withOpacity(0.3)),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: Color.fromRGBO(120, 78, 125, 1.0),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
  Widget signupButton(String disp){
    var fontDesign =  GoogleFonts.fredokaOne(
        color: Colors.white, fontSize: 15.0);
    return AbsorbPointer(
      absorbing: _isAbsorbing,
      child: Container(
        height: 0.0893*height,
        width: 0.8333 * width,
        margin: EdgeInsets.only(top: 0.0149*height*1.0),
        child: InkWell(
          splashColor: Colors.white,
          onTap: () {
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  transitionsBuilder: (context, animation,
                      secondaryAnimation, child) {
                    var begin = Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                disp.toUpperCase(),
                style: GoogleFonts.fredokaOne(
                    color: Colors.white, fontSize: 15.0),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(164, 173, 213, 1.0),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
