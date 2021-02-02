import 'dart:ui';

import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gtisma/CustomViews/CustomProgressBar.dart';
import 'package:gtisma/CustomViews/SocialMediaSignup.dart';
import 'package:gtisma/Screens/EyewitnessLogin.dart';
import 'package:gtisma/Screens/OTPVerification.dart';
import 'package:gtisma/helpers/DeviceInformation.dart';
import 'package:gtisma/helpers/GlobalVariables.dart';
import 'package:gtisma/helpers/NavigationPreferences.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:gtisma/helpers/push_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomDashboard.dart';
import 'DashboardItems.dart';
import 'EyewitnessDashboard.dart';
import 'IntroScreen.dart';

SelectLanguage lang = SelectLanguage();
var firstNameController = TextEditingController();
var lastNameController = TextEditingController();
var emailController = TextEditingController();
var phoneController = TextEditingController();
var passwordController = TextEditingController();
var repasswordController = TextEditingController();

class Experiment extends StatefulWidget {
  @override
  _ExperimentState createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  dynamic nativeLanguage = "";
  var url = 'https://www.geotiscm.org/api/gender';
  var registerURL = 'https://www.geotiscm.org/api/auth/register';
  var data;
  var len;
  var _currentItemSelected = '';
  var myData = [''];
  bool _isVisible = false;
  bool _isAbsorbing = false;
  bool _isRegisterVisible = false;
  String tokenFirebase = '';
  String deviceID = '';
  Future<void> initFirebase() async {
    tokenFirebase = await _firebaseMessaging.getToken();
    print('FirebaseMessaging token2: $tokenFirebase');
    UserPreferences().storeFirebaseID(tokenFirebase);
  }

  getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        deviceID = androidInfo.androidId.toString();
        UserPreferences().storeDeviceID(deviceID);
        print(androidInfo.androidId.toString()); //UUID of the device
      } else if (Platform.isIOS) {
        var ioSInfo = await deviceInfoPlugin.iosInfo;
        deviceID = ioSInfo.identifierForVendor.toString();
        UserPreferences().storeDeviceID(deviceID);
        print('Running on ${ioSInfo.identifierForVendor}');
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
  }

  faceBookGtismaLogin() async {
    debugPrint('Facebook Signup');
    final FacebookLogin facebookSignin = FacebookLogin();
    final result = await facebookSignin.logIn(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v3.3/me?fields=name,first_name,last_name,picture.width(800).height(800),friends,email&access_token=$token');
    final profile = json.decode(graphResponse.body);
    print(profile.toString());
    print(profile['name'].toString());
    print(profile['email'].toString());
    var picture = profile['picture']['data']['url'];
    UserPreferences().storeSocialLoginPicURL(picture.toString());
    UserPreferences().storeSocialLoginEmail(profile['email'].toString());
    UserPreferences().storeSocialLoginName(profile['name'].toString());
    UserPreferences().storeSocialLoginID(profile['id'].toString());
    SocialLoginUpload(
        profile['email'].toString(),
        profile['last_name'].toString(),
        profile['first_name'].toString(),
        tokenFirebase,
        deviceID,
        'facebook',
        picture.toString(),
        profile['id'].toString());
  }

  GoogleGtismaLogin() async {

    try {
      await _googleSignIn.signIn();
      setState(() {
        debugPrint(_googleSignIn.currentUser.photoUrl);
        debugPrint(_googleSignIn.currentUser.email);
        debugPrint(_googleSignIn.currentUser.displayName);
        debugPrint(_googleSignIn.currentUser.id);
        UserPreferences()
            .storeSocialLoginPicURL(_googleSignIn.currentUser.photoUrl);
        UserPreferences()
            .storeSocialLoginEmail(_googleSignIn.currentUser.email);
        UserPreferences()
            .storeSocialLoginName(_googleSignIn.currentUser.displayName);
        UserPreferences().storeSocialLoginID(_googleSignIn.currentUser.id);
        var fullName = _googleSignIn.currentUser.displayName.split(' ');
        var firstName = fullName[0];
        var lastName = fullName[1];
        SocialLoginUpload(
            _googleSignIn.currentUser.email,
            lastName,
            firstName,
            tokenFirebase,
            deviceID,
            'facebook',
            _googleSignIn.currentUser.photoUrl,
            _googleSignIn.currentUser.id);
      });
    } catch (error) {
      print(error);
    }
  }

  InstagramLogin() async {}

  void showNot(var message) {
    var notification = message['notification'];
    String title = notification['title'];
    String body = notification['body'];
    debugPrint(title);
    debugPrint(body);
    _showNotification(title.toString(), body.toString());
  }

  void initState() {
    // TODO: implement initState
    initFirebase();
    getDeviceInfo();

    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      showNot(message);
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      showNot(message);
    }, onResume: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      showNot(message);
    });
    // return not

    nativeLanguage = UserPreferences().data;
    _currentItemSelected = lang.languagTester(nativeLanguage)[22];
    myData = [lang.languagTester(nativeLanguage)[22]];
    UserPreferences().storeRegister(true);
    this.fetchData();
    super.initState();
    initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    initializationSettings = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotification(String title, String otp) async {
    await _demoNotification(title, otp);
    //await _showBigTextNotification();
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Ok'),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                )
              ],
            ));
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

  void setRegisterVisible() {
    setState(() {
      _isRegisterVisible = !_isRegisterVisible;
    });
  }

  Future<dynamic> signupData(
      String email,
      String last_name,
      String first_name,
      String phone,
      String password,
      String password_confirmation,
      String gender) async {
    debugPrint(email +
        last_name +
        first_name +
        phone +
        password +
        password_confirmation);
    if (email.isNotEmpty &&
        last_name.isNotEmpty &&
        first_name.isNotEmpty &&
        phone.isNotEmpty &&
        password.isNotEmpty &&
        password_confirmation.isNotEmpty) {
      var response = await http.post(Uri.encodeFull(registerURL), headers: {
        'clientId': 'mobileclientpqqh6ebizhTecUpfb0qA'
      }, body: {
        'email': email,
        'last_name': last_name,
        'first_name': first_name,
        'phone': phone,
        'password': password,
        'password_confirmation': password_confirmation,
        'gender_id': gender,
        'firebase_token': tokenFirebase,
        'device_id': deviceID
      });
      var cooldata = json.decode(response.body);
      if (response.statusCode == 422) {
        var firstInfo = "";
        var secondInfo = "";
        var thirdInfo = "";
        try {
          firstInfo = cooldata['errors']['email'][0].toString();
        } catch (e) {}
        try {
          secondInfo = cooldata['errors']['phone'][0].toString();
        } catch (e) {}
        try {
          thirdInfo = cooldata['errors']['password'][0].toString();
        } catch (e) {}
        showDialogBox(firstInfo + " " + secondInfo + " " + thirdInfo);
        setProgress();
        setAbsorb();
      } else {
        //suceessfully registered
        UserPreferences().saveRegisterStatus(true);
        UserPreferences().saveUserEmail(email);
        UserPreferences().saveSpecific('email', email);
        UserPreferences().saveSpecific('last_name', last_name);
        UserPreferences().saveSpecific('first_name', first_name);
        UserPreferences().saveSpecific('phone', phone);
        UserPreferences().saveSpecific('password', password);
        UserPreferences()
            .saveSpecific('password_confirmation', password_confirmation);
        UserPreferences().saveSpecific('gender_id', gender);
        //showDialogBox(cooldata['data'].toString());
        setProgress();
        setAbsorb();
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
                return OTPVerification();
              },
            ));
      }
      debugPrint(response.statusCode.toString());

      print(cooldata);
    } else {
      showDialogBox("Please fill any empty field");
      setProgress();
      setAbsorb();
    }

    return "Success";
  }

  Widget progressBar(BuildContext context, String disp) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      width: 300,
      height: 60,
      child: Column(
        children: [
          Container(
            //GoogleFonts.pacifico(color: Color.fromRGBO(120, 78, 125, 1.0), fontSize: 25.0
            height: 50,
            width: 300,
            child: AbsorbPointer(
              absorbing: _isAbsorbing,
              child: RaisedButton(
                shape: StadiumBorder(),
                color: Color.fromRGBO(120, 78, 125, 1.0),
                textColor: Colors.white,
                onPressed: () {
                  int i = myData.indexOf(_currentItemSelected);
                  if (i != 0) {
                    setState(() {
                      _isVisible = true;
                      _isAbsorbing = true;
                      //_isAbsorbing = true;
                      signupData(
                          emailController.text,
                          lastNameController.text,
                          firstNameController.text,
                          phoneController.text,
                          passwordController.text,
                          repasswordController.text,
                          i.toString());
                    });
                  } else {
                    showDialogBox(lang.languagTester(nativeLanguage)[22]);
                  }
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
                  height: 4, child: CustomProgressBar().customLinearProgress)),
        ],
      ),
    );
  }

  Future<String> fetchData() async {
    setRegisterVisible();
    var response = await http.get(Uri.encodeFull(url), headers: {
      'Accept': 'application/json',
      'clientId': 'mobileclientpqqh6ebizhTecUpfb0qA'
    });
    if (response.statusCode == 200) {
      var lp;
      List m;
      setState(() {
        data = jsonDecode(response.body);
        m = data["data"];
        lp = m.length;
      });
      //print(m[1].toString());
      for (int i = 0; i < lp; i++) {
        myData.add(m[i]['name'].toString());
      }
      setRegisterVisible();
    } else {
      setRegisterVisible();
    }

    // _listInfo.add(myData[i]['name'].toString());

    return "Success";
  }

  PageController pageController = PageController(
    initialPage: 0,
  );

  Widget buttonContinue(BuildContext cont, bool value, String disp) {
    return RaisedButton(
      shape: StadiumBorder(),

      textColor: Colors.white,
      color: Color.fromRGBO(120, 78, 125, 1.0),
      onPressed: () {
        if (value == false) {
          //debugPrint(firstNameController.text.toString());
          pageController.animateToPage(1,
              duration: Duration(milliseconds: 2000),
              curve: Curves.fastLinearToSlowEaseIn);
          debugPrint('Still on First Page');
        } else {
          debugPrint('Now on Second Page');
          //submit code here

        }
      },
      child: Text(
        disp.toUpperCase(),
        style:  GoogleFonts.fredokaOne(
            color: Colors.white, fontSize: 15.0),
      ),
    );
  }

  SocialMediaSignup design = SocialMediaSignup();
  @override
  Widget build(BuildContext context) {
    var fontDesign = GoogleFonts.fredokaOne(
        color: Color.fromRGBO(120, 78, 125, 1.0), fontSize: 18.0);
    return MaterialApp(
      title: 'EyewitnessReg',
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          Scaffold(
              backgroundColor: Color.fromRGBO(253, 253, 254, 1.0),
              appBar: AppBar(
                title: Text(
                  lang.languagTester(nativeLanguage)[14].toUpperCase(),
                  style: fontDesign,
                ),
                centerTitle: true,
                elevation: 2.0,
                backgroundColor: Colors.white,
                // backgroundColor: Color.fromRGBO(120, 78, 125, 1.0),
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // SizedBox(width: 200, height: 200, child: SvgPicture.asset('assets/images/signup.svg')),
                      Container(
                        width: 330,
                        height: 320,
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: pageController,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  width: 320,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 55,
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 0),
                                        child: TextFormField(
                                          controller: firstNameController,
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                242, 242, 242, 1.0),
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                            hintText: lang.languagTester(
                                                nativeLanguage)[15],
                                            labelText: lang.languagTester(
                                                nativeLanguage)[15],
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]),
                                            ),
                                            prefixIcon: const Icon(Icons.person,
                                                color: Color.fromRGBO(
                                                    120, 78, 125, 1.0)),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 55,
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 0),
                                        child: TextFormField(
                                          controller: lastNameController,
                                          keyboardType: TextInputType.name,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                242, 242, 242, 1.0),
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                            hintText: lang.languagTester(
                                                nativeLanguage)[16],
                                            labelText: lang.languagTester(
                                                nativeLanguage)[16],
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]),
                                            ),
                                            prefixIcon: const Icon(Icons.person,
                                                color: Color.fromRGBO(
                                                    120, 78, 125, 1.0)),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 55,
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 0),
                                        child: TextFormField(
                                          controller: emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                242, 242, 242, 1.0),
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                            hintText: lang.languagTester(
                                                nativeLanguage)[17],
                                            labelText: lang.languagTester(
                                                nativeLanguage)[17],
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]),
                                            ),
                                            prefixIcon: const Icon(Icons.email,
                                                color: Color.fromRGBO(
                                                    120, 78, 125, 1.0)),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 55,
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 0),
                                        child: TextFormField(
                                          controller: phoneController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                242, 242, 242, 1.0),
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                            hintText: lang.languagTester(
                                                nativeLanguage)[18],
                                            labelText: lang.languagTester(
                                                nativeLanguage)[18],
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]),
                                            ),
                                            prefixIcon: const Icon(Icons.phone,
                                                color: Color.fromRGBO(
                                                    120, 78, 125, 1.0)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 10.0, right: 30.0, left: 30.0),
                                  width: 300,
                                  height: 50,
                                  child: buttonContinue(
                                    context,
                                    false,
                                    lang.languagTester(nativeLanguage)[19],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  width: 320,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      FadeInDown(
                                        delay: Duration(milliseconds: 100),
                                        child: Container(
                                          height: 55,
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 10, 20, 0),
                                          child: TextFormField(
                                            controller: passwordController,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color.fromRGBO(
                                                  242, 242, 242, 1.0),
                                              contentPadding:
                                                  EdgeInsets.all(10.0),
                                              hintText: lang.languagTester(
                                                  nativeLanguage)[20],
                                              labelText: lang.languagTester(
                                                  nativeLanguage)[20],
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: BorderSide(
                                                    color: Colors.grey[300]),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                borderSide: BorderSide(
                                                    color: Colors.grey[300]),
                                              ),
                                              prefixIcon: const Icon(Icons.lock,
                                                  color: Color.fromRGBO(
                                                      120, 78, 125, 1.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      FadeInDown(
                                        delay: Duration(milliseconds: 150),
                                        child: Container(
                                        height: 55,
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 0),
                                        child: TextFormField(
                                          controller: repasswordController,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Color.fromRGBO(
                                                242, 242, 242, 1.0),
                                            contentPadding:
                                                EdgeInsets.all(10.0),
                                            hintText: lang.languagTester(
                                                nativeLanguage)[21],
                                            labelText: lang.languagTester(
                                                nativeLanguage)[21],
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300]),
                                            ),
                                            prefixIcon: const Icon(Icons.lock,
                                                color: Color.fromRGBO(
                                                    120, 78, 125, 1.0)),
                                          ),
                                        ),
                                      ),),
                                      FadeInDown(
                                        delay: Duration(milliseconds: 200),
                                        child: Container(
                                          height: 47,
                                          margin: EdgeInsets.only(
                                              top: 10.0, right: 20.0, left: 20.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            border: Border.all(
                                              color: Colors.grey[300],
                                              width: 1,
                                            ),
                                            color: Color.fromRGBO(
                                                242, 242, 242, 1.0),
                                          ),
                                          // alignment: Alignment.centerLeft,
                                          // width: 400,
                                          // padding: const EdgeInsets.fromLTRB(
                                          //     20, 1, 10, 0),
                                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                          child: Center(
                                            child: DropdownButton<String>(
                                              underline: SizedBox(height: 1.0),
                                              isExpanded: true,
                                              items: myData
                                                  .map((String dropDownStringItem) {
                                                return DropdownMenuItem<String>(
                                                  value: dropDownStringItem,
                                                  child: Text(dropDownStringItem, style: TextStyle(color: Colors.black)),
                                                );
                                              }).toList(),
                                              onChanged: (String newSelected) {
                                                debugPrint('Gender Selected');
                                                _dropDownSelectedaction(
                                                    newSelected);
                                              },
                                              value: _currentItemSelected,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 10.0, right: 30.0, left: 30.0),
                                    width: 300,
                                    height: 70,
                                    child: progressBar(
                                      context,
                                      lang.languagTester(nativeLanguage)[23],
                                    )),
                                TextButton(
                                  child: Text(
                                    lang.languagTester(nativeLanguage)[24],
                                    style: GoogleFonts.robotoSlab(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                  onPressed: () async {
                                    NavigationHelper().navigateAnotherPage(
                                        context, EyewitnessLoginStat());
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Opacity(
                                opacity: 0.5,
                                child: Text(
                                  'OR',
                                  style: GoogleFonts.robotoSlab(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w600),
                                ))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                      ),
                      Container(
                        child: SocialLoginPage(),
                      ),
                    ],
                  ),
                ),
              )),
          Visibility(
            visible:_isRegisterVisible,
            child: Container(
              child: Center(
                child: SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                    backgroundColor: Colors.blueAccent,
                    strokeWidth: 5.0,
                  ),
                ),
              ),
              color: Color.fromRGBO(255, 255, 255, 0.5),
            ),
          ),
        ],
      ),
    );
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

  void _dropDownSelectedaction(String newSelect) {
    setState(() {
      this._currentItemSelected = newSelect;
    });
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    await Navigator.push(context,
        new MaterialPageRoute(builder: (context) => OTPVerification()));
  }

  Future<void> _demoNotification(String title, String otp) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "channel_ID", 'channel name', 'channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'text ticker');
    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, otp, platformChannelSpecifics, payload: 'GTISMA OTP');
  }

  Widget SocialLoginPage() {
    return Container(
      child: Column(
        children: [
          Divider(),
          SizedBox(
            height: 35.0,
          ),
          SizedBox(
            width: 280.0,
            height: 50.0,
            child: SignInButton(
                buttonType: ButtonType.facebook,
                btnText: lang.languagTester(nativeLanguage)[33],
                onPressed: () async {
                  faceBookGtismaLogin();
                }),
          ),
          SizedBox(height: 10.0),
          SizedBox(
            width: 280.0,
            height: 50.0,
            child: SignInButton(
                buttonType: ButtonType.google,
                btnText: lang.languagTester(nativeLanguage)[34],
                onPressed: () async {
                  GoogleGtismaLogin();
                }),
          ),
        ],
      ),
    );
  }

  Future<dynamic> SocialLoginUpload(
      String email,
      String lastName,
      String firstName,
      String firebaseToken,
      String deviceId,
      String source,
      String pictureUrl,
      String facebookId) async {
    String socialURL = 'https://www.geotiscm.org/api/auth/socialregister';
    var response = await http.post(Uri.encodeFull(socialURL), headers: {
      'clientId': 'mobileclientpqqh6ebizhTecUpfb0qA'
    }, body: {
      'email': email,
      'last_name': lastName,
      'first_name': firstName,
      'firebase_token': firebaseToken,
      'device_id': deviceId,
      'source': source,
      'picture_url': pictureUrl,
      'facebook_id': facebookId,
    });
    var data = json.decode(response.body);
    debugPrint(data.toString());
    if (response.statusCode == 200) {
      UserPreferences().storeUserData(data['data']);
      if (source == 'facebook') {
        UserPreferences().storeLoginType('Facebook');
        List<String> personalInfo = await GetUser().getLoginUser(data['data']);
        UserPreferences().storeUserTypeId(int.parse(personalInfo[4]));
        NavigationPreferences().storeLoginScreen(true);
        NavigationHelper().navigateAnotherPage(context,  CustomDashboard(pageType: false));
      } else {
        UserPreferences().storeLoginType('Google');
        List<String> personalInfo = await GetUser().getLoginUser(data['data']);
        UserPreferences().storeUserTypeId(int.parse(personalInfo[4]));
        NavigationPreferences().storeLoginScreen(true);
        NavigationHelper().navigateAnotherPage(context,  CustomDashboard(pageType: false));
      }
    } else {
      showDialogBox("An Error Occurred! Please try again");
    }
  }

  showMyDialog(){

  }
}
